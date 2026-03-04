extends Node2D

var first = true

func _ready():
	$"Fade/Fade Timer".start()
	$Fade.show()
	$Fade/AnimationPlayer.play("fade_out_black")
	$AnimationPlayer.play("Credit_Scroll")

func _on_back_pressed() -> void:
	_on_animation_player_animation_finished("Credit_Scroll")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	await get_tree().create_timer(3).timeout
	$"Fade/Fade Timer".start()
	$Fade.show()
	$Fade/AnimationPlayer.play("fade_in_black")

func _on_fade_timer_timeout() -> void:
	if first:
		first = false
		$Fade.hide()
	else:
		get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
