extends Node2D

@onready var current_level = get_tree().current_scene
@onready var settings = $Settings

signal restart()
signal resume()

func _process(_delta: float) -> void:
	if (settings.visible == true):
		print (settings.visible)
		await get_tree().create_timer(0.5).timeout
		get_tree().paused = true
	if (settings.visible == false):
		get_tree().paused = false

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
	get_tree().paused = false
	AudioManager.ball_hit(1)
	get_tree().change_scene_to_file("res://scenes/menus/level_select.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	AudioManager.ball_hit(1)
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
	


func _on_settings_button_pressed() -> void:
	settings.Location = "Level Paused"
	settings.visible = true
	
