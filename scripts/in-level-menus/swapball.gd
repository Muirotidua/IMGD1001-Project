extends Control
@onready var ball_label = $"BallNameLabel"
@onready var ball_desc = $BallDescription

signal swap_cue(new_type: GlobalEnums.BallType)

var ball_availability: Array[GlobalEnums.BallAvailability]
const UD_LABEL: String = "?????"
const UD_DESC: String = "Ball has not been discovered"
const UA_DESC: String = "Ball currently unavailable"
const UD_COL: Color = Color(0.1, 0.1, 0.1)
const UA_COL: Color = Color(0.3, 0.3, 0.3)
const A_COL: Color = Color(1, 1, 1)
const colors: Array[Color] = [A_COL, UA_COL, UD_COL]

func _ready():
	for i in range(GlobalEnums.BallType.size()):
		ball_availability.append(GlobalEnums.BallAvailability.UNDISCOVERED)

func color():
	$Icon_Image.modulate = colors[ball_availability[GlobalEnums.BallType.EXPLOSION]]
	$Icon_Button.modulate = colors[ball_availability[GlobalEnums.BallType.EXPLOSION]]
	$FullballImage.modulate = colors[ball_availability[GlobalEnums.BallType.NORMAL]]
	$FullballButton.modulate = colors[ball_availability[GlobalEnums.BallType.NORMAL]]
	$Hollowball_Image.modulate = colors[ball_availability[GlobalEnums.BallType.NORMAL]]
	$HollowballButton.modulate = colors[ball_availability[GlobalEnums.BallType.NORMAL]]


func close():
	get_tree().paused = false
	visible = false

func _on_fullball_button_pressed() -> void:
	if ball_availability[GlobalEnums.BallType.NORMAL] == GlobalEnums.BallAvailability.AVAILABLE:
		close()
		swap_cue.emit(GlobalEnums.BallType.NORMAL)


func _on_hollowball_button_pressed() -> void:
	if ball_availability[GlobalEnums.BallType.NORMAL] == GlobalEnums.BallAvailability.AVAILABLE:
		close()
		swap_cue.emit(GlobalEnums.BallType.NORMAL)

func _on_icon_button_pressed() -> void:
	if ball_availability[GlobalEnums.BallType.EXPLOSION] == GlobalEnums.BallAvailability.AVAILABLE:
		close()
		swap_cue.emit(GlobalEnums.BallType.EXPLOSION)


func _on_icon_button_mouse_entered() -> void:
	$Icon_Image.visible = true
	ball_label.text = "Explosion Cue"
	ball_desc.text = "Caution: Explodes On Contact!"
	if ball_availability[GlobalEnums.BallType.EXPLOSION] == GlobalEnums.BallAvailability.UNDISCOVERED:
		ball_label.text = UD_LABEL
		ball_desc.text = UD_DESC
	elif ball_availability[GlobalEnums.BallType.EXPLOSION] == GlobalEnums.BallAvailability.UNAVAILABLE:
		ball_desc.text = UA_DESC
	ball_label.visible = true
	ball_desc.visible = true

func _on_hollowball_button_mouse_entered() -> void:
	$Hollowball_Image.visible = true
	ball_label.text = "Hollow Cue"
	ball_desc.text = "Lighter than a Feather."
	if ball_availability[GlobalEnums.BallType.NORMAL] == GlobalEnums.BallAvailability.UNDISCOVERED:
		ball_label.text = UD_LABEL
		ball_desc.text = UD_DESC
	elif ball_availability[GlobalEnums.BallType.NORMAL] == GlobalEnums.BallAvailability.UNAVAILABLE:
		ball_desc.text = UA_DESC
	ball_label.visible = true
	ball_desc.visible = true

func _on_fullball_button_mouse_entered() -> void:
	$FullballImage.visible = true
	ball_label.text = "White Cue"
	ball_desc.text = "Standard. Classic. Iconic."
	if ball_availability[GlobalEnums.BallType.NORMAL] == GlobalEnums.BallAvailability.UNDISCOVERED:
		ball_label.text = UD_LABEL
		ball_desc.text = UD_DESC
	elif ball_availability[GlobalEnums.BallType.NORMAL] == GlobalEnums.BallAvailability.UNAVAILABLE:
		ball_desc.text = UA_DESC
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
