extends Control
@onready var ball_label = $"BallNameLabel"
@onready var ball_desc = $BallDescription

signal swap_cue(new_type: GlobalEnums.BallType)

func _on_fullball_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	swap_cue.emit(GlobalEnums.BallType.NORMAL)


func _on_hollowball_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	swap_cue.emit(GlobalEnums.BallType.NORMAL)

func _on_icon_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	swap_cue.emit(GlobalEnums.BallType.EXPLOSION)


func _on_icon_button_mouse_entered() -> void:
	$Icon_Image.visible = true
	ball_label.text = "Explosion Cue"
	ball_desc.text = "Caution: Explodes On Contact!"
	ball_label.visible = true
	ball_desc.visible = true

func _on_hollowball_button_mouse_entered() -> void:
	$Hollowball_Image.visible = true
	ball_label.text = "Hollow Cue"
	ball_desc.text = "Lighter than a Feather."
	ball_label.visible = true
	ball_desc.visible = true

func _on_fullball_button_mouse_entered() -> void:
	$FullballImage.visible = true
	ball_label.text = "White Cue"
	ball_desc.text = "Standard. Classic. Iconic."
	ball_label.visible = true
	ball_desc.visible = true

func _on_fullball_button_mouse_exited() -> void:
	$FullballImage.visible = false
	ball_label.visible = false
	ball_desc.visible = false


func _on_hollowball_button_mouse_exited() -> void:
	$Hollowball_Image.visible = false
	ball_label.visible = false
	ball_desc.visible = false

func _on_icon_button_mouse_exited() -> void:
	$Icon_Image.visible = false
	ball_label.visible = false
	ball_desc.visible = false
