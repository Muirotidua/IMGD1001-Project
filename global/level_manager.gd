extends Node

const level_count = 11
var level_unlocked: Array[bool]
var level_stars: Array[int]
var type_discovered: Array[bool]
var unlock_all = true


var billiards_record: int = 0

func _ready() -> void:
	for i in range(level_count):
		level_unlocked.append(unlock_all)
		level_stars.append(0)
	level_unlocked[0] = true
	for i in range(GlobalEnums.BallType.size()):
		type_discovered.append(false)
	type_discovered[0] = true

func unlock_level(level_id: int):
	if level_id > level_count || level_id <= 0:
		print("Level ID out of range")
		return
	level_unlocked[level_id - 1] = true

func set_stars(level_id:int, star_count: int):
	if level_id > level_count || level_id <= 0:
		print("Level ID out of range")
		return
	if star_count > level_stars[level_id - 1]:
		level_stars[level_id - 1] = star_count

func switch_level(level_id: int):
	if level_id > level_count || level_id <= 0:
		print("Level ID out of range")
		return
	print("Level " + str(level_id))
	if !level_unlocked[level_id - 1]:
		print("Level is not unlocked")
		return
	if level_id == 1:
		get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")
	elif level_id == 2:
		get_tree().change_scene_to_file("res://scenes/levels/level2.tscn")
	elif level_id == 3:
		get_tree().change_scene_to_file("res://scenes/levels/level3.tscn")
	elif level_id == 4:
		get_tree().change_scene_to_file("res://scenes/levels/level4.tscn")
	elif level_id == 5:
		get_tree().change_scene_to_file("res://scenes/levels/level5.tscn")
	elif level_id == 6:
		get_tree().change_scene_to_file("res://scenes/levels/level6.tscn")
	elif level_id == 7:
		get_tree().change_scene_to_file("res://scenes/levels/level7.tscn")
	elif level_id == 8:
		get_tree().change_scene_to_file("res://scenes/levels/level8.tscn")
	elif level_id == 9:
		get_tree().change_scene_to_file("res://scenes/levels/level9.tscn")
	elif level_id == 10:
		get_tree().change_scene_to_file("res://scenes/levels/level10.tscn")
	elif level_id == 11:
		get_tree().change_scene_to_file("res://scenes/levels/billiards.tscn")
	else:
		print("Level does not exist")
		get_tree().change_scene_to_file("res://scenes/menus/level_select.tscn")
	return
