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
@onready var back: Button = $BackButton

const UNLOCKED: Color = Color(1, 1, 1)
const LOCKED: Color = Color(0.5, 0.5, 0.5)

func _ready() -> void:
	if !LevelManager.level2_unlocked:
		lev2.modulate = LOCKED 
	if !LevelManager.level3_unlocked:
		lev3.modulate = LOCKED 
	if !LevelManager.level4_unlocked:
		lev4.modulate = LOCKED
	if !LevelManager.level5_unlocked:
		lev5.modulate = LOCKED
	if !LevelManager.level6_unlocked:
		lev6.modulate = LOCKED
	if !LevelManager.level7_unlocked:
		lev7.modulate = LOCKED
	if !LevelManager.level8_unlocked:
		lev8.modulate = LOCKED
	if !LevelManager.level9_unlocked:
		lev9.modulate = LOCKED
	if !LevelManager.level10_unlocked:
		lev10.modulate = LOCKED
		

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
