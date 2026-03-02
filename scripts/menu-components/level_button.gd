extends Button

func _on_pressed() -> void:
	AudioManager.ball_hit(1)
	LevelManager.switch_level(int(get_text()))

	
