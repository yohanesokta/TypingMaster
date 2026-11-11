class_name Dool
extends AnimatedSprite2D

signal broken
signal vanished

@export var max_hits: int = 2

var hits: int = 0
var is_breaking: bool = false
var is_dead: bool = false

func _ready() -> void:
	if sprite_frames != null:
		if sprite_frames.has_animation(&"hit"):
			sprite_frames.set_animation_loop(&"hit", false)
		if sprite_frames.has_animation(&"breaking"):
			sprite_frames.set_animation_loop(&"breaking", false)
	animation_finished.connect(_on_animation_finished)
	play(&"idle")

func take_hit() -> void:
	if is_breaking or is_dead:
		return
	hits += 1
	if hits < max_hits:
		play(&"hit")
	else:
		is_breaking = true
		play(&"breaking")
		_handle_breaking()

func _on_animation_finished() -> void:
	if animation == &"hit" and not is_breaking:
		play(&"idle")

func _handle_breaking() -> void:
	await animation_finished
	broken.emit()
	await get_tree().create_timer(2.0).timeout
	is_dead = true
	vanished.emit()
	queue_free()
