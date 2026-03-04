extends Node2D

@onready var lev1: Button = $LB/LevelButton1
@onready var lev2: Button = $LB/LevelButton2
@onready var lev3: Button = $LB/LevelButton3
@onready var lev4: Button = $LB/LevelButton4
@onready var lev5: Button = $LB/LevelButton5
@onready var lev6: Button = $LB/LevelButton6
@onready var lev7: Button = $LB/LevelButton7
@onready var lev8: Button = $LB/LevelButton8
@onready var lev9: Button = $LB/LevelButton9
@onready var lev10: Button = $LB/LevelButton10
@onready var freeplay: Button = $FB/FreeplayButton
@onready var back: Button = $BackButton
@onready var cam: Camera2D = $Camera2D
@onready var fade: ColorRect = $Fade
@onready var fade_anim: AnimationPlayer = $Fade/AnimationPlayer

var clicked: int = -1

var levButtons: Array[Button]
var starIcons: Array[Texture] = [preload("res://visuals/UI/LevelButton.png"), 
	preload("res://visuals/UI/LevelButton1Star.png"), 
	preload("res://visuals/UI/LevelButton2Star.png"), 
	preload("res://visuals/UI/LevelButton3Star.png")]

const UNLOCKED: Color = Color(1, 1, 1)
const LOCKED: Color = Color(0.5, 0.5, 0.5)


func _ready() -> void:
	cam.make_current()
	cam.global_position = get_viewport_rect().size / 2
	lev1.switch.connect(button_pressed)
	lev2.switch.connect(button_pressed)
	lev3.switch.connect(button_pressed)
	lev4.switch.connect(button_pressed)
	lev5.switch.connect(button_pressed)
	lev6.switch.connect(button_pressed)
	lev7.switch.connect(button_pressed)
	lev8.switch.connect(button_pressed)
	lev9.switch.connect(button_pressed)
	lev10.switch.connect(button_pressed)
	freeplay.switch.connect(button_pressed)
	fade.finished.connect(on_anim_end)
	$LB.global_position = Vector2(0, -800)
	var btween: Tween = create_tween()
	btween.set_ease(Tween.EASE_OUT)
	btween.set_trans(Tween.TRANS_CUBIC)
	btween.tween_property($LB, "position:y", 0, 0.5)
	
	$FB.global_position = Vector2(0, 300)
	var ftween: Tween = create_tween()
	ftween.set_ease(Tween.EASE_OUT)
	ftween.set_trans(Tween.TRANS_CUBIC)
	ftween.tween_property($FB, "position:y", 0, 0.5)
	
	fade.hide()
	
	levButtons = [lev1, lev2, lev3, lev4, lev5, lev6, lev7, lev8, lev9, lev10]
	for i in range(LevelManager.level_count - 1):
		if !LevelManager.level_unlocked[i]:
			levButtons[i].modulate = LOCKED
		else:
			levButtons[i].modulate = UNLOCKED
		levButtons[i].icon = starIcons[LevelManager.level_stars[i]]
	if LevelManager.level_unlocked[LevelManager.level_count - 1]:
		freeplay.disabled = false
		freeplay.show()
	else:
		freeplay.disabled = true
		freeplay.hide()

func _on_back_button_pressed() -> void:
	clicked = 0
	fade_anim.play("fade_in_black")
	fade.show()
	$Fade/FadeTimer.start()

func button_pressed(level: int, pos: Vector2):
	if !LevelManager.level_unlocked[level - 1]:
		return
	if clicked == -1:
		fade_anim.play("fade_in_black")
		fade.show()
		$Fade/FadeTimer.start()
		clicked = level
		var ztween: Tween = create_tween()
		var ttween: Tween = create_tween()
		ztween.set_ease(Tween.EASE_OUT)
		ztween.set_trans(Tween.TRANS_QUAD)
		ttween.set_ease(Tween.EASE_OUT)
		ttween.set_trans(Tween.TRANS_QUAD)
		ztween.tween_property(cam, "zoom", Vector2(3, 3), 1)
		ttween.tween_property(cam, "position", pos, 1)

func _on_fade_timer_timeout() -> void:
	if clicked == 0:
		get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
	else: LevelManager.switch_level(clicked)

func on_anim_end():
	fade_anim.play("fade_in_black")
