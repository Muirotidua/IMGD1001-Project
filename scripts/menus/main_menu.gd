extends Node2D

@onready var settings = $Settings
@onready var cam = $Camera2D

var clicked = null;


func _ready() -> void:
	cam.make_current()
	cam.position = Vector2(0, 0)
	if LevelManager.menu_load == GlobalEnums.LoadAnim.FADE:
		$"Fade/Fade Timer".start()
		$Fade.show()
		$Fade/AnimationPlayer.play("fade_out_black")
	else:
		tween_in()
	LevelManager.menu_load = GlobalEnums.LoadAnim.FADE
	$TitleTexts/AnimatedSprite2D.play()
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
		$"Fade/Fade Timer".start()
		#AudioManager.play("res://sounds/sfx/billiard-break.mp3")
		AudioManager.ball_break()
	

func _on_version_notes_pressed() -> void:
	if clicked == null:
		clicked = "version_notes";
		$"Fade/Fade Timer".start()
		tween_out()
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
	
func _on_settings_pressed() -> void:
	if clicked == null:
		clicked = "settings";
		$"Fade/Fade Timer".start()
		tween_out()
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

func tween_out():
	var ctween: Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	ctween.tween_property(cam, "position:y", 1500, 1)
	
func tween_in():
	cam.position = Vector2(0, 1500)
	var ctween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	ctween.tween_property(cam, "position:y", 0, 1)
