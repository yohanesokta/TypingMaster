class_name BackgroundLoop
extends Node2D

@export var segment_width: float = 1196.0
@export var camera: Camera2D

var segments: Array[StaticBody2D] = []

func _ready() -> void:
	for child: Node in get_children():
		if child is StaticBody2D:
			segments.append(child as StaticBody2D)

func _physics_process(_delta: float) -> void:
	var active_camera: Camera2D = camera
	if active_camera == null:
		active_camera = get_viewport().get_camera_2d()
	if active_camera == null:
		return
	var viewport_width: float = get_viewport_rect().size.x
	var left_threshold: float = active_camera.global_position.x - (viewport_width * 0.5)
	for segment: StaticBody2D in segments:
		if segment.global_position.x + segment_width < left_threshold:
			var max_x: float = _get_farthest_x()
			segment.global_position.x = max_x + segment_width

func _get_farthest_x() -> float:
	var max_x: float = -INF
	for segment: StaticBody2D in segments:
		if segment.global_position.x > max_x:
			max_x = segment.global_position.x
	return max_x
