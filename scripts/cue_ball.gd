class_name CueBall extends BaseBall

# Launch Multiplier
@export var lm: float = 20
@export var rapid_fire: bool = false
@export var infinite_shots: bool = false
@export var charge_rate = 40
# initial shot number that is incremented for each type of shot. 
# when it is greater than number of level shots the level triggers failstate

var rewinded: bool = false
var shot_power = 0;
var MAX_HOLD = 50
enum BallType{NORMAL, EXPLOSION}
var ball_type : BallType

@onready var shot_count = 0
@onready var count_label: Label = $NonRotate/CountLabel
@onready var pointer: Line2D = $PointerLine
@onready var pool_cue: PoolStick = $PoolStick

@onready var stick_pos: Vector2 = global_position

var shot_ready:bool  = true

signal try_shoot()

func _ready():
	super._ready()
	shot_count = 0
	if debug_labels:
		count_label.show()
	else:
		count_label.hide()
	pointer.add_point(Vector2.ZERO)
	pointer.add_point(get_local_mouse_position())
	type = GlobalEnums.BallType.CUE_BALL
	%ProgressBar.visible = false 
	ball_type = BallType.NORMAL
	sprite.play("default")


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if(Input.is_action_just_pressed("switch_type")):
		switch_type()  
	if(Input.is_action_pressed("ball_hit")&&shot_ready):
		if debug_labels:
			%ProgressBar.show()   
		if(shot_power < MAX_HOLD):
			shot_power += charge_rate * delta
		%ProgressBar.value = shot_power
		pool_cue.distance = shot_power
		pool_cue.show()
		stick_pos = global_position
	if(Input.is_action_just_released("ball_hit")&&shot_ready):
		try_shoot.emit()
		%ProgressBar.hide()
		pool_cue.reset()  
		print("Ball Type:", ball_type )


func _process(_delta: float) -> void:
	pointer.set_point_position(1, get_local_mouse_position())
	#%ProgressBar.rotation = rotation*-1
	#%ProgressBar.position = Vector2(-(%ProgressBar.size.x/2),30).rotated(rotation*-1)
	#%PoolStick.
	if debug_labels:
		count_label.text = str(shot_count)
	if shot_ready:
		pointer.show()
	else:
		pointer.hide()
	pool_cue.global_position = stick_pos

func on_shoot():
	var direction = global_position.direction_to(get_global_mouse_position())
	#var s = global_position.distance_to(get_global_mouse_position())
	var power_multiplier = shot_power * 2
	print(shot_power)
	apply_central_impulse(direction * lm * power_multiplier)
	await get_tree().create_timer(.1).timeout
	shot_power = 0
	#inmotion = true
	if !infinite_shots:
		shot_count += 1 # no ++ operator :(
	rewinded = false

func reset():
	shot_count = 0
	shot_power = 0
	super.reset()

func rewind():
	if !rewinded:
		shot_count -= 1
	rewinded = true
	shot_power = 0
	super.rewind()

func _on_body_entered(_body: Node) -> void:
	if(ball_type == BallType.EXPLOSION):
		var balls = %ExplosionArea.get_overlapping_bodies()
		print(balls)
		for ball in balls:
			if (ball is PoolBall || ball is EightBall):
				var impulse = ball.position-position 
				ball.apply_impulse(impulse*10)

func switch_type():
	if (ball_type == BallType.NORMAL):
		ball_type = BallType.EXPLOSION
		sprite.play("explosion_ball")
	else:
		ball_type = BallType.NORMAL
		sprite.play("default")
	print(ball_type)
