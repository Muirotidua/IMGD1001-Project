extends ColorRect

signal finished

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	print("Fade Done")
	finished.emit()
