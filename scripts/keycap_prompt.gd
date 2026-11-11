class_name KeycapPrompt
extends Control

const FONT_TYPE: FontFile = preload("res://assets/fonts/TYPE_FONTS.ttf")

var panel: PanelContainer
var label: Label
var current_letter: String = ""

func _ready() -> void:
	custom_minimum_size = Vector2(56.0, 56.0)
	size = Vector2(56.0, 56.0)
	pivot_offset = Vector2(28.0, 28.0)
	
	panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(56.0, 56.0)
	panel.size = Vector2(56.0, 56.0)
	
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.18, 0.2, 0.24)
	style.set_corner_radius_all(10)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 6
	style.border_color = Color(0.1, 0.11, 0.14)
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.45)
	style.shadow_size = 4
	style.shadow_offset = Vector2(0.0, 3.0)
	panel.add_theme_stylebox_override(&"panel", style)
	
	label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_override(&"font", FONT_TYPE)
	label.add_theme_font_size_override(&"font_size", 28)
	label.add_theme_color_override(&"font_color", Color.WHITE)
	
	panel.add_child(label)
	add_child(panel)
	visible = false

func set_letter(letter: String) -> void:
	current_letter = letter.to_upper()
	if label != null:
		label.text = current_letter
	visible = true
	scale = Vector2.ONE
	modulate = Color.WHITE

func play_success() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"scale", Vector2(1.2, 1.2), 0.08)
	tween.parallel().tween_property(self, ^"modulate", Color(0.3, 1.0, 0.4), 0.08)
	tween.tween_property(self, ^"scale", Vector2.ONE, 0.08)
	tween.parallel().tween_property(self, ^"modulate", Color.WHITE, 0.08)

func play_error() -> void:
	if panel == null:
		return
	var tween: Tween = create_tween()
	tween.tween_property(panel, ^"modulate", Color(1.0, 0.25, 0.25), 0.06)
	tween.tween_property(panel, ^"position:x", -6.0, 0.04)
	tween.tween_property(panel, ^"position:x", 6.0, 0.04)
	tween.tween_property(panel, ^"position:x", -4.0, 0.04)
	tween.tween_property(panel, ^"position:x", 0.0, 0.04)
	tween.parallel().tween_property(panel, ^"modulate", Color.WHITE, 0.08)

func hide_prompt() -> void:
	visible = false
	current_letter = ""
