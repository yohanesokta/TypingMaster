class_name Slime
extends AnimatedSprite2D

signal hit_taken
signal defeated
signal vanished

@export var max_hits: int = 2

var hits: int = 0
var is_dead: bool = false
var is_attacking: bool = false

func _ready() -> void:
	if sprite_frames != null:
		if sprite_frames.has_animation(&"green_attack"):
			sprite_frames.set_animation_loop(&"green_attack", false)
		if sprite_frames.has_animation(&"green_idle"):
			sprite_frames.set_animation_loop(&"green_idle", true)
	animation_finished.connect(_on_animation_finished)
	play(&"green_idle")

func take_hit() -> void:
	if is_dead:
		return
	hits += 1
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"modulate", Color(1.5, 0.3, 0.3), 0.1)
	tween.tween_property(self, ^"modulate", Color.WHITE, 0.15)
	if hits < max_hits:
		hit_taken.emit()
	else:
		is_dead = true
		defeated.emit()
		_handle_defeat()

func attack_player() -> void:
	if is_dead or is_attacking:
		return
	is_attacking = true
	play(&"green_attack")

func _on_animation_finished() -> void:
	if animation == &"green_attack":
		is_attacking = false
		if not is_dead:
			play(&"green_idle")

func _handle_defeat() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"modulate:a", 0.0, 0.6)
	tween.parallel().tween_property(self, ^"scale", Vector2(scale.x * 1.3, 0.05), 0.6)
	await tween.finished
	vanished.emit()
	queue_free()
