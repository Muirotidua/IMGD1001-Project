extends RigidBody2D

func _input(event):
	if(event.is_action_pressed("ball_hit")):
		var direction = position.direction_to(get_global_mouse_position())
		apply_central_impulse(direction*1000)
