extends Button

signal switch(level: int, pos: Vector2)

func _on_pressed() -> void:
	switch.emit(int(get_text()), Vector2(global_position.x + (size.x / 2), global_position.y  + (size.y / 2)))
	#LevelManager.switch_level(int(get_text()))

	
