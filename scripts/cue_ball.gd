extends RigidBody2D

@onready var speed_label: Label = $Label
@export var dls = 1000 # Default Launch Speed
var inmotion: bool = false
var speed

func _input(event):
	if(event.is_action_pressed("ball_hit")):
		var direction = position.direction_to(get_global_mouse_position())
		if !inmotion:
			apply_central_impulse(direction*dls)
	if(event.is_action_pressed("move_left")):
		pass

func _physics_process(delta: float) -> void:
	speed = abs(linear_velocity.length())
	speed_label.text = str(speed)
	if speed < 10:
		linear_damp = 50
		if speed < 1:
			linear_damp = 1
			inmotion = false
	else:
		inmotion = true
