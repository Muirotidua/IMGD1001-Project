extends Node2D

var clicked = null;

func _ready() -> void:
	$"Fade/Fade Timer".start()
	$Fade/AnimationPlayer.play("fade_out_black")
	

func _on_start_pressed() -> void:
	if clicked == null:
		clicked = "start";
		$Fade.show()
		$"Fade/Fade Timer".start()
		$Fade/AnimationPlayer.play("fade_in_black")
		#AudioManager.play("res://sounds/sfx/billiard-break.mp3")
		AudioManager.ball_break.play()
	

func _on_version_notes_pressed() -> void:
	if clicked == null:
		clicked = "version_notes";
		$Fade.show()
		$"Fade/Fade Timer".start()
		$Fade/AnimationPlayer.play("fade_in_black")
		%OptionSelect.play()


func _on_credits_pressed() -> void:
	if clicked == null:
		clicked = "credits";
		$Fade.show()
		$"Fade/Fade Timer".start()
		$Fade/AnimationPlayer.play("fade_in_black")
		%OptionSelect.play()


func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_fade_timer_timeout() -> void:
	if clicked == "start":
		get_tree().change_scene_to_file("res://scenes/level_select.tscn")
	if clicked == "credits":
		get_tree().change_scene_to_file("res://scenes/credits.tscn")
	if clicked == "version_notes":
		get_tree().change_scene_to_file("res://scenes/version_history.tscn")
