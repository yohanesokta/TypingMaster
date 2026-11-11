class_name Player
extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = -450.0
@export var push_force: float = 12000.0
@export var camera: Camera2D
@export var attack_range: float = 85.0

@onready var sprite: AnimatedSprite2D = get_node_or_null(^"PlayerSprites") as AnimatedSprite2D

var is_combat_locked: bool = false

func _ready() -> void:
	if sprite == null:
		sprite = get_node_or_null(^"CollisionShape2D/PlayerSprites") as AnimatedSprite2D
	if camera == null:
		camera = get_viewport().get_camera_2d()

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
	var target_dool: Dool = _find_target_dool()
	if target_dool != null:
		_start_dool_attack(target_dool)
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

func _find_target_dool() -> Dool:
	var dool_nodes: Array[Node] = get_tree().get_nodes_in_group(&"dool")
	if dool_nodes.is_empty():
		var node: Node = get_parent().get_node_or_null(^"dool")
		if node is Dool:
			dool_nodes.append(node)
	for node: Node in dool_nodes:
		if node is Dool:
			var dool: Dool = node as Dool
			if not dool.is_breaking and not dool.is_dead:
				var dist: float = dool.global_position.x - global_position.x
				if dist > 0.0 and dist <= attack_range:
					return dool
	return null

func _start_dool_attack(dool: Dool) -> void:
	is_combat_locked = true
	velocity.x = 0.0
	var camera_controller: CameraController = camera as CameraController
	if camera_controller != null:
		camera_controller.is_paused = true
	if sprite != null:
		sprite.play(&"Attack")
	await get_tree().create_timer(0.25).timeout
	if is_instance_valid(dool):
		dool.take_hit()
	await get_tree().create_timer(0.35).timeout
	await get_tree().create_timer(0.2).timeout
	if sprite != null:
		sprite.play(&"Attack")
	await get_tree().create_timer(0.25).timeout
	if is_instance_valid(dool):
		dool.take_hit()
	await get_tree().create_timer(0.35).timeout
	if sprite != null:
		sprite.play(&"Idle")
	if is_instance_valid(dool):
		await dool.vanished
	if camera_controller != null:
		camera_controller.is_paused = false
	is_combat_locked = false

func _handle_rigid_collisions() -> void:
	for i: int in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		var collider: Object = collision.get_collider()
		if collider is RigidBody2D:
			var rigid_body: RigidBody2D = collider as RigidBody2D
			var push_direction: Vector2 = -collision.get_normal()
			var contact_offset: Vector2 = collision.get_position() - rigid_body.global_position
			rigid_body.apply_force(push_direction * push_force, contact_offset)
