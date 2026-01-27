extends Node2D

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Credit_Scroll":
		$CreditsText.scroll_active = true
