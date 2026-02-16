class_name PoolStick
extends Node2D 

var distance = 0 # distance from center
var paused: bool = false
var freeze_rotation: float

func _ready():
	%PoolStickSpr.play()

func _process(_delta: float) -> void:
	%PoolStickSpr.position = Vector2((distance*-2)+(-945.0),-10) # manual direction offset
	if !paused:
		look_at(get_viewport().get_mouse_position())
	else:
		global_rotation = freeze_rotation
	
  
func reset():
	distance = 0;
	paused = true
	freeze_rotation = global_rotation
	await get_tree().create_timer(1).timeout
	paused = false
	hide()
