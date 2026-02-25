extends Control
@onready var ball_label = $"BallNameLabel"
@onready var ball_desc = $BallDescription
@onready var hover_icon = $FullBall
@onready var normal_img = $Normal
@onready var pocket_img = $Pocket
@onready var explosion_img = $Explosion


signal swap_cue(new_type: GlobalEnums.BallType)

var ball_availability: Array[GlobalEnums.BallAvailability]
const UD_LABEL: String = "?????"
const UD_DESC: String = "Ball has not been discovered"
const UA_DESC: String = "Ball currently unavailable"
const UD_COL: Color = Color(0, 0, 0)
const UA_COL: Color = Color(0.3, 0.3, 0.3)
const A_COL: Color = Color(1, 1, 1)
const colors: Array[Color] = [A_COL, UA_COL, UD_COL]

func _ready():
	for i in range(GlobalEnums.BallType.size()):
		ball_availability.append(GlobalEnums.BallAvailability.UNDISCOVERED)
	

func color():
	if ball_availability[GlobalEnums.BallType.NORMAL] != GlobalEnums.BallAvailability.UNDISCOVERED:
		normal_img.play("default")
		normal_img.modulate = colors[ball_availability[GlobalEnums.BallType.NORMAL]]
		if ball_availability[GlobalEnums.BallType.NORMAL] == GlobalEnums.BallAvailability.UNAVAILABLE:
			$Lock_N.visible = true
	else:
		normal_img.play("undiscovered")
	if ball_availability[GlobalEnums.BallType.EXPLOSION] != GlobalEnums.BallAvailability.UNDISCOVERED:
		explosion_img.play("explosion_ball")
		explosion_img.modulate = colors[ball_availability[GlobalEnums.BallType.EXPLOSION]]
		if ball_availability[GlobalEnums.BallType.EXPLOSION] == GlobalEnums.BallAvailability.UNAVAILABLE:
			$Lock_E.visible = true
	else:
		explosion_img.play("undiscovered")
	if ball_availability[GlobalEnums.BallType.POCKET] != GlobalEnums.BallAvailability.UNDISCOVERED:
		pocket_img.play("pocket_ball")
		pocket_img.modulate = colors[ball_availability[GlobalEnums.BallType.POCKET]]
		if ball_availability[GlobalEnums.BallType.POCKET] == GlobalEnums.BallAvailability.UNAVAILABLE:
			$Lock_P.visible = true
	else:
		pocket_img.play("undiscovered")


func close():
	get_tree().paused = false
	visible = false

func _on_fullball_button_pressed() -> void:
	if ball_availability[GlobalEnums.BallType.NORMAL] == GlobalEnums.BallAvailability.AVAILABLE:
		close()
		swap_cue.emit(GlobalEnums.BallType.NORMAL)


func _on_hollowball_button_pressed() -> void:
	if ball_availability[GlobalEnums.BallType.POCKET] == GlobalEnums.BallAvailability.AVAILABLE:
		close()
		swap_cue.emit(GlobalEnums.BallType.POCKET)

func _on_icon_button_pressed() -> void:
	if ball_availability[GlobalEnums.BallType.EXPLOSION] == GlobalEnums.BallAvailability.AVAILABLE:
		close()
		swap_cue.emit(GlobalEnums.BallType.EXPLOSION)


func _on_icon_button_mouse_entered() -> void:
	hover_icon.modulate = colors[ball_availability[GlobalEnums.BallType.EXPLOSION]]
	hover_icon.visible = true
	hover_icon.play("explosion_ball")
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
	hover_icon.modulate = colors[ball_availability[GlobalEnums.BallType.POCKET]]
	hover_icon.visible = true
	hover_icon.play("pocket_ball")
	ball_label.text = "Pocket Ball"
	ball_desc.text = "I think you dropped something!"
	if ball_availability[GlobalEnums.BallType.POCKET] == GlobalEnums.BallAvailability.UNDISCOVERED:
		ball_label.text = UD_LABEL
		ball_desc.text = UD_DESC
	elif ball_availability[GlobalEnums.BallType.POCKET] == GlobalEnums.BallAvailability.UNAVAILABLE:
		ball_desc.text = UA_DESC
	ball_label.visible = true
	ball_desc.visible = true

func _on_fullball_button_mouse_entered() -> void:
	hover_icon.modulate = colors[ball_availability[GlobalEnums.BallType.NORMAL]]
	hover_icon.visible = true
	hover_icon.play("default")
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
	hover_icon.visible = false
	ball_label.visible = false
	ball_desc.visible = false


func _on_hollowball_button_mouse_exited() -> void:
	hover_icon.visible = false
	ball_label.visible = false
	ball_desc.visible = false

func _on_icon_button_mouse_exited() -> void:
	hover_icon.visible = false
	ball_label.visible = false
	ball_desc.visible = false
