extends Node2D

@onready var current_level = get_tree().current_scene

signal restart()
signal redo()
signal transfer(dest: GlobalEnums.Destination)

func _on_redo_pressed() -> void:
	AudioManager.ball_hit(1)
	redo.emit()


func _on_restart_pressed() -> void:
	AudioManager.ball_hit(1)
	restart.emit()


func _on_level_select_pressed() -> void:
	AudioManager.ball_hit(1)
	transfer.emit(GlobalEnums.Destination.LEVEL_SELECT)


func _on_main_menu_pressed() -> void:
	AudioManager.ball_hit(1)
	transfer.emit(GlobalEnums.Destination.MAIN_MENU)

func clear() -> void:
	AudioManager.ball_hit(1)
	visible = false
	get_tree().paused = false
