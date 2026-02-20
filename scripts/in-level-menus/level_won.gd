extends Node2D

@onready var current_level = get_tree().current_scene

signal restart()
signal next_lev()


func _on_continue_pressed() -> void:
	next_lev.emit()

func _on_restart_pressed() -> void:
	restart.emit()


func _on_level_select_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/level_select.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func clear() -> void:
	visible = false
	get_tree().paused = false
