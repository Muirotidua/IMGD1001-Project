extends Node2D

@onready var current_level = get_tree().current_scene

signal restart()
signal resume()

func _on_resume_pressed() -> void:
	AudioManager.ball_hit(1)
	visible = false
	get_tree().paused = false
	resume.emit()

func _on_restart_pressed() -> void:
	AudioManager.ball_hit(1)
	visible = false
	get_tree().paused = false
	resume.emit()
	restart.emit()


func _on_level_select_pressed() -> void:
	AudioManager.ball_hit(1)
	get_tree().change_scene_to_file("res://scenes/menus/level_select.tscn")


func _on_main_menu_pressed() -> void:
	AudioManager.ball_hit(1)
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
	
