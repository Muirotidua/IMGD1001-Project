extends Node2D

@onready var current_level = get_tree().current_scene
@onready var settings = $Settings

signal restart()
signal resume()
signal transfer(dest: GlobalEnums.Destination)

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
	transfer.emit(GlobalEnums.Destination.LEVEL_SELECT)


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	AudioManager.ball_hit(1)
	transfer.emit(GlobalEnums.Destination.MAIN_MENU)
	


func _on_settings_button_pressed() -> void:
	settings.Location = "Level Paused"
	settings.visible = true
	
