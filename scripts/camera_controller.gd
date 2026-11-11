class_name CameraController
extends Camera2D

@export var speed: float = 200.0

func _physics_process(delta: float) -> void:
	global_position.x += speed * delta
