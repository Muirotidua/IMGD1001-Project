class_name CueBall extends BaseBall

# Launch Multiplier
@export var lm: float = 1
@export var infinite_shots: bool = false

@onready var pointer = $PointerLine
var shot_ready:bool  = true

signal try_shoot()

func _ready():
	super._ready()
	pointer.add_point(Vector2.ZERO)
	pointer.add_point(get_local_mouse_position())
	type = GlobalEnums.BallType.CUE_BALL


func _input(event):
	if(event.is_action_pressed("ball_hit")):
		try_shoot.emit()
		


func _process(delta: float) -> void:
	pointer.set_point_position(1, get_local_mouse_position())
	if shot_ready:
		pointer.show()
	else:
		pointer.hide()
		
		
func on_shoot():
	var direction = global_position.direction_to(get_global_mouse_position())
	var s = global_position.distance_to(get_global_mouse_position())
	if !inmotion || infinite_shots:
		apply_central_impulse(direction * lm * s)
	
	
