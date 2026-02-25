extends Node2D

@onready var current_level = get_tree().current_scene

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/info-pages/credits.tscn")
