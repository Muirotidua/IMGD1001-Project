extends Button


func _on_pressed() -> void:
	LevelManager.switch_level(int(get_text()))
