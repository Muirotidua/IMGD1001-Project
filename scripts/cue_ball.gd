class_name CueBall extends BaseBall

# Launch Multiplier
@export var lm: float = 20
@export var infinite_shots: bool = false
@export var shot_count = 0
# initial shot number that is incremented for each type of shot. 
# when it is greater than number of level shots the level triggers failstate

var shot_power = 0;
var MAX_HOLD = 50

@onready var pointer = $PointerLine
var shot_ready:bool  = true

signal try_shoot()

func _ready():
	super._ready()
	pointer.add_point(Vector2.ZERO)
	pointer.add_point(get_local_mouse_position())
	type = GlobalEnums.BallType.CUE_BALL
	%ProgressBar.visible = false
	%PoolStick.visible = false


func _input(event):
	if(event.is_action("ball_hit")&&shot_ready):
		%ProgressBar.show()
		
		if(shot_power < MAX_HOLD):
			shot_power += 1
		%ProgressBar.value = shot_power 
		
		
	if(event.is_action_released("ball_hit")&&shot_ready):
		try_shoot.emit()
		%ProgressBar.hide()



func _process(_delta: float) -> void:
	pointer.set_point_position(1, get_local_mouse_position())
	%ProgressBar.rotation = rotation*-1
	%ProgressBar.position = Vector2(-(%ProgressBar.size.x/2),30).rotated(rotation*-1)
	#%PoolStick.
	
	if shot_ready:
		pointer.show()
	else:
		pointer.hide()
		
		
func on_shoot():
	var direction = global_position.direction_to(get_global_mouse_position())
	#var s = global_position.distance_to(get_global_mouse_position())
	var power_multiplier = shot_power * 2
	if !inmotion || infinite_shots:
		print(shot_power)
		apply_central_impulse(direction * lm * power_multiplier)
		await get_tree().create_timer(.1).timeout
		shot_power = 0
		#inmotion = true
		shot_count += 1 # no ++ operator :(
	
	
	
