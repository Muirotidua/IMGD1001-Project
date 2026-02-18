extends Node

var level2_unlocked: bool = false
var level3_unlocked: bool = false
var level4_unlocked: bool = false
var level5_unlocked: bool = false
var level6_unlocked: bool = false
var level7_unlocked: bool = false
var level8_unlocked: bool = false
var level9_unlocked: bool = false
var level10_unlocked: bool = false

#if we do stars
var level1_stars = 0
var level2_stars = 0
var level3_stars = 0
var level4_stars = 0
var level5_stars = 0
var level6_stars = 0
var level7_stars = 0
var level8_stars = 0
var level9_stars = 0
var level10_stars = 0

func unlock_level(level_id: int):
	if level_id == 2:
		level2_unlocked = true
	elif level_id == 3:
		level3_unlocked = true
	elif level_id == 4:
		level4_unlocked = true
	elif level_id == 5:
		level5_unlocked = true
	if level_id == 6:
		level6_unlocked = true
	if level_id == 7:
		level7_unlocked = true
	if level_id == 8:
		level8_unlocked = true
	if level_id == 9:
		level9_unlocked = true
	if level_id == 10:
		level10_unlocked = true

func switch_level(level_id: int):
	print("Level " + str(level_id))
	if level_id == 1:
		get_tree().change_scene_to_file("res://scenes/level_one.tscn")
	elif level_id == 2 && level2_unlocked:
		get_tree().change_scene_to_file("res://scenes/level_two.tscn")
	elif level_id == 3 && level3_unlocked:
		get_tree().change_scene_to_file("res://scenes/level_three.tscn")
	elif level_id == 4 && level4_unlocked:
		get_tree().change_scene_to_file("res://scenes/level_select.tscn")
	elif level_id == 5 && level5_unlocked:
		get_tree().change_scene_to_file("res://scenes/level_select.tscn")
	elif level_id == 6 && level6_unlocked:
		get_tree().change_scene_to_file("res://scenes/level_select.tscn")
	elif level_id == 7 && level7_unlocked:
		get_tree().change_scene_to_file("res://scenes/level_select.tscn")
	elif level_id == 8 && level8_unlocked:
		get_tree().change_scene_to_file("res://scenes/level_select.tscn")
	elif level_id == 9 && level9_unlocked:
		get_tree().change_scene_to_file("res://scenes/level_select.tscn")
	elif level_id == 10 && level10_unlocked:
		get_tree().change_scene_to_file("res://scenes/level_select.tscn")
	else:
		print("Level does not exist or is not unlocked")
		pass
