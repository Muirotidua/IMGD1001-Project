extends Node2D

@onready var lev1: Button = $LevelButton1
@onready var lev2: Button = $LevelButton2
@onready var lev3: Button = $LevelButton3
@onready var lev4: Button = $LevelButton4
@onready var lev5: Button = $LevelButton5
@onready var lev6: Button = $LevelButton6
@onready var lev7: Button = $LevelButton7
@onready var lev8: Button = $LevelButton8
@onready var lev9: Button = $LevelButton9
@onready var lev10: Button = $LevelButton10
@onready var freeplay: Button = $FreeplayButton
@onready var back: Button = $BackButton

var levButtons: Array[Button]
var starIcons: Array[Texture] = [preload("res://visuals/UI/LevelButton.png"), 
	preload("res://visuals/UI/LevelButton1Star.png"), 
	preload("res://visuals/UI/LevelButton2Star.png"), 
	preload("res://visuals/UI/LevelButton3Star.png")]

const UNLOCKED: Color = Color(1, 1, 1)
const LOCKED: Color = Color(0.5, 0.5, 0.5)


func _ready() -> void:
	levButtons = [lev1, lev2, lev3, lev4, lev5, lev6, lev7, lev8, lev9, lev10]
	for i in range(LevelManager.level_count - 1):
		if !LevelManager.level_unlocked[i]:
			levButtons[i].modulate = LOCKED
		else:
			levButtons[i].modulate = UNLOCKED
		levButtons[i].icon = starIcons[LevelManager.level_stars[i]]
	if LevelManager.level_unlocked[LevelManager.level_count - 1]:
		freeplay.disabled = false
		freeplay.show()
	else:
		freeplay.disabled = true
		freeplay.hide()

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
