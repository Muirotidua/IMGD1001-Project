class_name PoolStick extends Node2D 

var distance = 0 # distance from center
var paused: bool = false # if the stick is paused in place after shooting
var freeze_rotation: float 
var pausable: bool = true # if the stick should pause after shooting (for use with rewind / reset)

func _ready():
	%PoolStickSpr.play()

func _process(_delta: float) -> void:
	%PoolStickSpr.position = Vector2((distance*-2)+(-945.0),-10) # manual direction offset
	if !paused:
		look_at(get_viewport().get_mouse_position())
	else:
		global_rotation = freeze_rotation
	
  
func reset():
	# The modification of this code was important trust
	if !pausable:
		return
	distance = 0;
	paused = true
	freeze_rotation = global_rotation
	%Timer.start()

func _on_timer_timeout() -> void:
	%Timer.stop()
	paused = false
	hide()
	pausable = false
