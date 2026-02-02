extends BaseBall

# Default Launch Speed
@export var dls = 1000
@export var infinite_shots: bool = false

@onready var pointer = $PointerLine

func _ready():
	super._ready()
	pointer.add_point(Vector2.ZERO)
	pointer.add_point(get_local_mouse_position())


func _input(event):
	if(event.is_action_pressed("ball_hit")):
		var direction = global_position.direction_to(get_global_mouse_position())
		if !inmotion || infinite_shots:
			apply_central_impulse(direction * dls)


func _process(delta: float) -> void:
	pointer.set_point_position(1, get_local_mouse_position())
	if inmotion:
		pointer.hide()
	if !inmotion:
		pointer.show()
		
		
	
	
	
