extends Node2D

@onready var startSelect = $"Start Select" # start select plays when player starts game. - EH
@onready var optionSelect = $"Option Select" # option select plays when player selects any other button. A better name is possible. - EH

var clicked = null;
var loaded = false;

func _ready() -> void:
	$"Fade/Fade Timer".start()
	$Fade/AnimationPlayer.play("fade_out_black")

func _on_start_pressed() -> void:
	clicked = "start";
	$"Fade/Fade Timer".start()
	$Fade/AnimationPlayer.play("fade_in_black")
	startSelect.play() #This gets cut off by scene transition. Could rework to be shorter than fade, but an option that doesn't require that is preferable - EH
	

func _on_version_notes_pressed() -> void:
	clicked = "version_notes";
	$Fade.show()
	$"Fade/Fade Timer".start()
	$Fade/AnimationPlayer.play("fade_in_black")
	optionSelect.play()


func _on_credits_pressed() -> void:
	clicked = "credits";
	$Fade.show()
	$"Fade/Fade Timer".start()
	$Fade/AnimationPlayer.play("fade_in_black")
	optionSelect.play()


func _on_quit_pressed() -> void:
	get_tree().quit()
	optionSelect.play()
	

func _on_fade_timer_timeout() -> void:
	if !loaded:
		loaded = true
	else:
		if clicked == "start":
			get_tree().change_scene_to_file("res://scenes/survivorsgame.tscn")
