class_name Player
extends CharacterBody2D

const LETTERS: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const KeycapPromptClass: GDScript = preload("res://scripts/keycap_prompt.gd")
const TutorialBannerClass: GDScript = preload("res://scripts/tutorial_banner.gd")

@export var speed: float = 200.0
@export var jump_velocity: float = -450.0
@export var push_force: float = 12000.0
@export var camera: Camera2D
@export var attack_range: float = 90.0
@export var max_health: int = 100
@export var keycap_offset: Vector2 = Vector2(-28.0, -195.0)

@onready var sprite: AnimatedSprite2D = get_node_or_null(^"PlayerSprites") as AnimatedSprite2D

var health: int = 100
var is_combat_locked: bool = false
var is_typing_active: bool = false
var expected_letter: String = ""
var current_enemy: Node2D = null

var keycap: Control
var tutorial_banner: CanvasLayer

func _ready() -> void:
	health = max_health
	if sprite == null:
		sprite = get_node_or_null(^"CollisionShape2D/PlayerSprites") as AnimatedSprite2D
	if camera == null:
		camera = get_viewport().get_camera_2d()
	
	keycap = KeycapPromptClass.new()
	keycap.position = keycap_offset
	add_child(keycap)
	
	tutorial_banner = TutorialBannerClass.new()
	add_child(tutorial_banner)

func _physics_process(delta: float) -> void:
	if camera == null:
		camera = get_viewport().get_camera_2d()
	if camera != null:
		var camera_controller: CameraController = camera as CameraController
		if camera_controller != null and not is_combat_locked:
			speed = camera_controller.speed
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_combat_locked:
		velocity.x = 0.0
		move_and_slide()
		_handle_rigid_collisions()
		return
	var target: Node2D = _find_target_enemy()
	if target != null:
		_engage_enemy(target)
		velocity.x = 0.0
		move_and_slide()
		_handle_rigid_collisions()
		return
	if Input.is_action_just_pressed(&"ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	velocity.x = speed
	if camera != null:
		var screen_left: float = camera.global_position.x - (get_viewport_rect().size.x * 0.5) + 32.0
		if global_position.x < screen_left:
			velocity.x = maxf(velocity.x, speed * 1.5)
	move_and_slide()
	_handle_rigid_collisions()
	if sprite != null:
		if is_on_floor():
			if absf(velocity.x) > 1.0:
				sprite.play(&"Run")
			else:
				sprite.play(&"Idle")
		else:
			sprite.play(&"Run")

func _unhandled_key_input(event: InputEvent) -> void:
	if not is_typing_active:
		return
	if not event.is_pressed() or event.is_echo():
		return
	if event is InputEventKey:
		var key_event: InputEventKey = event as InputEventKey
		var typed_str: String = OS.get_keycode_string(key_event.keycode).to_upper()
		if typed_str.length() == 1 and typed_str >= "A" and typed_str <= "Z":
			get_viewport().set_input_as_handled()
			if typed_str == expected_letter:
				keycap.play_success()
				_on_correct_key_pressed()
			else:
				keycap.play_error()
				_on_wrong_key_pressed()

func _find_target_enemy() -> Node2D:
	var candidates: Array[Node2D] = []
	var dool_nodes: Array[Node] = get_tree().get_nodes_in_group(&"dool")
	if dool_nodes.is_empty() and get_parent() != null:
		var d_node: Node = get_parent().get_node_or_null(^"dool")
		if d_node is Node2D:
			dool_nodes.append(d_node)
	for n: Node in dool_nodes:
		if n is Dool:
			var d: Dool = n as Dool
			if not d.is_breaking and not d.is_dead:
				candidates.append(d)
	
	var slime_nodes: Array[Node] = get_tree().get_nodes_in_group(&"slime")
	if slime_nodes.is_empty() and get_parent() != null:
		var s_node: Node = get_parent().get_node_or_null(^"Slime")
		if s_node is Node2D:
			slime_nodes.append(s_node)
	for n: Node in slime_nodes:
		if n is Slime:
			var s: Slime = n as Slime
			if not s.is_dead:
				candidates.append(s)
	
	var closest: Node2D = null
	var min_dist: float = INF
	for enemy: Node2D in candidates:
		var dist: float = enemy.global_position.x - global_position.x
		if dist > 0.0 and dist <= attack_range:
			if dist < min_dist:
				min_dist = dist
				closest = enemy
	return closest

func _engage_enemy(enemy: Node2D) -> void:
	is_combat_locked = true
	velocity.x = 0.0
	current_enemy = enemy
	var camera_controller: CameraController = camera as CameraController
	if camera_controller != null:
		camera_controller.is_paused = true
	if sprite != null:
		sprite.play(&"Idle")
	if enemy is Dool:
		tutorial_banner.show_message("TUTORIAL: Tekan huruf yang muncul di atas kepala karakter untuk menyerang!")
	expected_letter = _generate_random_letter()
	keycap.set_letter(expected_letter)
	is_typing_active = true

func _on_correct_key_pressed() -> void:
	is_typing_active = false
	if sprite != null:
		sprite.play(&"Attack")
	await get_tree().create_timer(0.2).timeout
	if is_instance_valid(current_enemy):
		if current_enemy is Dool:
			var dool: Dool = current_enemy as Dool
			dool.take_hit()
		elif current_enemy is Slime:
			var slime: Slime = current_enemy as Slime
			slime.take_hit()
	await get_tree().create_timer(0.3).timeout
	_check_enemy_state_after_hit()

func _check_enemy_state_after_hit() -> void:
	if not is_instance_valid(current_enemy):
		_resume_movement()
		return
	if current_enemy is Dool:
		var dool: Dool = current_enemy as Dool
		if dool.hits < dool.max_hits:
			tutorial_banner.show_message("Bagus! Tekan huruf berikutnya untuk menghancurkan boneka!")
			expected_letter = _generate_next_letter(expected_letter)
			keycap.set_letter(expected_letter)
			if sprite != null:
				sprite.play(&"Idle")
			is_typing_active = true
		else:
			keycap.hide_prompt()
			tutorial_banner.show_message("Hebat! Boneka hancur! Bersiaplah terus maju!")
			if sprite != null:
				sprite.play(&"Idle")
			await dool.vanished
			tutorial_banner.fade_out()
			_resume_movement()
	elif current_enemy is Slime:
		var slime: Slime = current_enemy as Slime
		if slime.hits < slime.max_hits:
			expected_letter = _generate_next_letter(expected_letter)
			keycap.set_letter(expected_letter)
			if sprite != null:
				sprite.play(&"Idle")
			is_typing_active = true
		else:
			keycap.hide_prompt()
			if sprite != null:
				sprite.play(&"Idle")
			await slime.vanished
			_resume_movement()

func _on_wrong_key_pressed() -> void:
	health = maxi(0, health - 10)
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"modulate", Color(1.5, 0.3, 0.3), 0.1)
	tween.tween_property(self, ^"modulate", Color.WHITE, 0.15)
	if is_instance_valid(current_enemy) and current_enemy is Slime:
		(current_enemy as Slime).attack_player()

func _resume_movement() -> void:
	current_enemy = null
	is_combat_locked = false
	is_typing_active = false
	keycap.hide_prompt()
	var camera_controller: CameraController = camera as CameraController
	if camera_controller != null:
		camera_controller.is_paused = false

func _generate_random_letter() -> String:
	var idx: int = randi() % LETTERS.length()
	return LETTERS.substr(idx, 1)

func _generate_next_letter(prev: String) -> String:
	var next_let: String = _generate_random_letter()
	while next_let == prev:
		next_let = _generate_random_letter()
	return next_let

func _handle_rigid_collisions() -> void:
	for i: int in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		var collider: Object = collision.get_collider()
		if collider is RigidBody2D:
			var rigid_body: RigidBody2D = collider as RigidBody2D
			var push_direction: Vector2 = -collision.get_normal()
			var contact_offset: Vector2 = collision.get_position() - rigid_body.global_position
			rigid_body.apply_force(push_direction * push_force, contact_offset)
