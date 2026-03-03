extends Node2D

@onready var cam = $Camera2D
@onready var timer = $Camera2D/Timer

func _ready():
	cam.make_current()
	cam.position = Vector2(0, -1500)
	var ctween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	ctween.tween_property(cam, "position:y", 0, 1)

func _on_back_pressed() -> void:
	timer.start()
	var ctween: Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	ctween.tween_property(cam, "position:y", -1500, 1)

func _on_timer_timeout() -> void:
	LevelManager.menu_load = GlobalEnums.LoadAnim.SPECIAL
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
