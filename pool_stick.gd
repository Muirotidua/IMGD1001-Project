class_name PoolStick
extends Node2D 

var distance = 0 # distance from center
var ball_target : CueBall = null

func _ready():
	self.global_position = ball_target.global_position

func _process(_delta: float) -> void:

	%PoolStickSpr.position = Vector2((distance*-1)+(-936.0),0) # manual direction offset
	
	look_at(get_viewport().get_mouse_position())

func reset():
	distance = 0;
	%PoolStickSpr.pause()
	await get_tree().create_timer(1).timeout
	%PoolStickSpr.play()
	hide()
	queue_free()
