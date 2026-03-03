extends Node2D

@onready var settings = $Settings

var clicked = null;


func _ready() -> void:
	$"Fade/Fade Timer".start()
	$Fade.show()
	$Fade/AnimationPlayer.play("fade_out_black")
	$Ball.play()
	$Ball.global_position = Vector2(720, 650)
	$Stick.play()
	$Stick.global_position = Vector2(-3400, 600)
	if(!AudioManager.music.playing):
		AudioManager.music.play()


func _on_start_pressed() -> void:
	if clicked == null:
		something_clicked()
		clicked = "start";
		$Fade.show()
		$"Fade/Fade Timer".start()
		#$Fade/AnimationPlayer.play("fade_in_black")
		#AudioManager.play("res://sounds/sfx/billiard-break.mp3")
		AudioManager.ball_break()
	

func _on_version_notes_pressed() -> void:
	if clicked == null:
		clicked = "version_notes";
		$Fade.show()
		$"Fade/Fade Timer".start()
		#$Fade/AnimationPlayer.play("fade_in_black")
		%OptionSelect.play()


func _on_credits_pressed() -> void:
	if clicked == null:
		clicked = "credits";
		$Fade.show()
		$"Fade/Fade Timer".start()
		#$Fade/AnimationPlayer.play("fade_in_black")
		%OptionSelect.play()


func _on_quit_pressed() -> void:
	get_tree().quit()
	
func _on_settings_pressed() -> void:
	if clicked == null:
		clicked = "settings";
		$Fade.show()
		$"Fade/Fade Timer".start()
		$Fade/AnimationPlayer.play("fade_in_black")
		%OptionSelect.play()

func _on_fade_timer_timeout() -> void:
	if clicked == "start":
		get_tree().change_scene_to_file("res://scenes/menus/level_select.tscn")
	if clicked == "credits":
		get_tree().change_scene_to_file("res://scenes/info-pages/credits.tscn")
	if clicked == "version_notes":
		get_tree().change_scene_to_file("res://scenes/info-pages/version_history.tscn")
	if clicked == "settings":
		settings.Location = "Main Menu"
		get_tree().change_scene_to_file("res://scenes/menus/settings.tscn")

func something_clicked():
	AudioManager.ball_hit_menu()
	$Stick.global_position = Vector2(-3100, 600)
	var title_tween: Tween = create_tween()
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	title_tween.set_ease(Tween.EASE_IN)
	title_tween.set_trans(Tween.TRANS_CUBIC)
	title_tween.tween_property($TitleTexts, "position:y", -500, 0.5)
	tween.tween_property($Ball, "position:x", 2500, 0.5)
	tween.tween_property($Stick, "position:x", -4000, 0.2)
