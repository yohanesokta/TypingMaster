class_name Player
extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = -450.0
@export var push_force: float = 12000.0
@export var camera: Camera2D

@onready var sprite: AnimatedSprite2D = get_node_or_null(^"PlayerSprites") as AnimatedSprite2D

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
		if camera_controller != null:
			speed = camera_controller.speed
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed(&"ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	velocity.x = speed
	if camera != null:
		var screen_left: float = camera.global_position.x - (get_viewport_rect().size.x * 0.5) + 32.0
		if global_position.x < screen_left:
			velocity.x = maxf(velocity.x, speed * 1.5)
	move_and_slide()
	for i: int in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		var collider: Object = collision.get_collider()
		if collider is RigidBody2D:
			var rigid_body: RigidBody2D = collider as RigidBody2D
			var push_direction: Vector2 = -collision.get_normal()
			var contact_offset: Vector2 = collision.get_position() - rigid_body.global_position
			rigid_body.apply_force(push_direction * push_force, contact_offset)
	if sprite != null:
		if is_on_floor():
			if absf(velocity.x) > 1.0:
				sprite.play(&"Run")
			else:
				sprite.play(&"Idle")
		else:
			sprite.play(&"Run")
