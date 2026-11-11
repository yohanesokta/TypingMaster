class_name CameraController
extends Camera2D

@export var speed: float = 200.0

var is_paused: bool = false

func _physics_process(delta: float) -> void:
	if not is_paused:
		global_position.x += speed * delta
