extends BaseBall

# Default Launch Speed
@export var dls = 1000
@export var infinite_shots: bool = false

func _input(event):
	if(event.is_action_pressed("ball_hit")):
		var direction = global_position.direction_to(get_global_mouse_position())
		if !inmotion || infinite_shots:
			apply_central_impulse(direction * dls)
