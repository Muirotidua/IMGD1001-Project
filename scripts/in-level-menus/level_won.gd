extends Node2D

@onready var current_level = get_tree().current_scene

signal restart()
signal transfer(dest: GlobalEnums.Destination)


func _on_continue_pressed() -> void:
	AudioManager.ball_hit(1)
	transfer.emit(GlobalEnums.Destination.NEXT)


func _on_restart_pressed() -> void:
	AudioManager.ball_hit(1)
	restart.emit()


func _on_level_select_pressed() -> void:
	get_tree().paused = false
	AudioManager.ball_hit(1)
	transfer.emit(GlobalEnums.Destination.LEVEL_SELECT)


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	AudioManager.ball_hit(1)
	transfer.emit(GlobalEnums.Destination.MAIN_MENU)
	

func clear() -> void:
	visible = false
	get_tree().paused = false
