class_name TutorialBanner
extends CanvasLayer

const FONT_DIALOG: FontFile = preload("res://assets/fonts/DIALOG_FONTS.ttf")

var panel: PanelContainer
var label: Label

func _ready() -> void:
	layer = 10
	
	panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(720.0, 72.0)
	
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.05, 0.08, 0.92)
	style.set_corner_radius_all(10)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.85, 0.85, 0.88, 0.7)
	style.content_margin_left = 24.0
	style.content_margin_right = 24.0
	style.content_margin_top = 14.0
	style.content_margin_bottom = 14.0
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.5)
	style.shadow_size = 6
	style.shadow_offset = Vector2(0.0, 4.0)
	panel.add_theme_stylebox_override(&"panel", style)
	
	label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_override(&"font", FONT_DIALOG)
	label.add_theme_font_size_override(&"font_size", 20)
	label.add_theme_color_override(&"font_color", Color.WHITE)
	
	panel.add_child(label)
	add_child(panel)
	
	panel.anchor_left = 0.5
	panel.anchor_right = 0.5
	panel.anchor_top = 0.0
	panel.anchor_bottom = 0.0
	panel.offset_left = -360.0
	panel.offset_right = 360.0
	panel.offset_top = 24.0
	panel.offset_bottom = 96.0
	
	panel.visible = false

func show_message(text: String) -> void:
	if label != null and panel != null:
		label.text = text
		panel.visible = true
		panel.modulate.a = 1.0

func fade_out() -> void:
	if panel != null and panel.visible:
		var tween: Tween = create_tween()
		tween.tween_property(panel, ^"modulate:a", 0.0, 0.5)
		await tween.finished
		panel.visible = false
