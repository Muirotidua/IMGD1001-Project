class_name CueBall extends BaseBall

# Launch Multiplier
@export var lm: float = 20
@export var impulse_multiplier: float = 40
@export var rapid_fire: bool = false
@export var infinite_shots: bool = false
@export var change_anytime: bool = false
@export var charge_rate = 40
@export var ball_type: GlobalEnums.BallType = GlobalEnums.BallType.NORMAL
# initial shot number that is incremented for each type of shot. 
# when it is greater than number of level shots the level triggers failstate

var rewinded: bool = true
var shot_power = 0;
var MAX_HOLD = 50
var ball_sprite_list: Array[String] = ["default", "explosion_ball", "pocket_ball"]
var available_types: Array[GlobalEnums.BallType]
var explosion_spawn = preload("res://scenes/ball-components/explosion_animation.tscn")
var shot_count_track = 0
var start_available_types: Array[GlobalEnums.BallType]
var last_available_types: Array[GlobalEnums.BallType]

@onready var shot_count = 0
@onready var count_label: Label = $NonRotate/CountLabel
@onready var pointer: Line2D = $PointerLine
@onready var pool_stick: PoolStick = $PoolStick

@onready var stick_pos: Vector2 = global_position

var shot_ready:bool  = true
var charging: bool = false

signal try_shoot()
signal swapped_ball()
signal spawning_pocket(pos: Vector2)

func _ready():
	super._ready()
	shot_count = 0
	if debug_labels:
		count_label.show()
	else:
		count_label.hide()
	pointer.add_point(Vector2.ZERO)
	pointer.add_point(get_local_mouse_position())
	%ProgressBar.visible = false 
	await get_tree().create_timer(.1).timeout
	start_available_types = available_types.duplicate()
	super.reset()


func _physics_process(delta: float) -> void:	
	super._physics_process(delta)
	if(Input.is_action_just_pressed("switch_type_left")):
		switch_type_dir("l")
	if(Input.is_action_just_pressed("switch_type_right")):
		switch_type_dir("r")
	if(Input.is_action_pressed("ball_hit")&&shot_ready):
		charging = true
		pool_stick.pausable = true
		if debug_labels:
			%ProgressBar.show()   
		if(shot_power < MAX_HOLD):
			shot_power += charge_rate * delta
		%ProgressBar.value = shot_power
		pool_stick.distance = shot_power
		pool_stick.show()
		stick_pos = global_position
	elif charging:
		charging = false
		try_shoot.emit()
		%ProgressBar.hide()                                                                
		pool_stick.reset()                                               
		print("Ball Type: ", ball_type)


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
	pool_stick.global_position = stick_pos

func on_shoot():
	var direction = global_position.direction_to(get_global_mouse_position())
	#var s = global_position.distance_to(get_global_mouse_position())
	var power_multiplier = shot_power * 2
	set_last_available()
	print(shot_power)
	apply_central_impulse(direction * lm * power_multiplier)
	await get_tree().create_timer(.1).timeout
	shot_power = 0
	#inmotion = true
	if !infinite_shots:
		if (ball_type == GlobalEnums.BallType.NORMAL):
			shot_count += 1 # no ++ operator :(
			shot_count_track = 1
		if (ball_type == GlobalEnums.BallType.EXPLOSION):
			shot_count += 2
			shot_count_track = 2
		if (ball_type == GlobalEnums.BallType.POCKET):
			shot_count += 1
			shot_count_track = 1
		
	rewinded = false

func reset():
	shot_count = 0
	shot_power = 0
	available_types = start_available_types.duplicate()
	pool_stick._on_timer_timeout()
	super.reset()
	

func rewind():
	if !rewinded:
		shot_count -= shot_count_track
	rewinded = true
	available_types = last_available_types.duplicate(true)
	shot_power = 0
	pool_stick._on_timer_timeout()
	super.rewind()
	
	

func _on_body_entered(body: Node) -> void:
	if(ball_type == GlobalEnums.BallType.EXPLOSION):
		var balls = %ExplosionArea.get_overlapping_bodies()
		print(balls)
		for ball in balls:
			if (ball is PoolBall || ball is EightBall):
				var impulse = ball.position-position 
				ball.apply_impulse(impulse*impulse_multiplier)
		call_deferred("spawn_explosion")
		await get_tree().create_timer(0.1).timeout
		(switch_type_spc(GlobalEnums.BallType.NORMAL))
	if(ball_type == GlobalEnums.BallType.POCKET):
		call_deferred("spawn_pocket")
		switch_type_spc(GlobalEnums.BallType.NORMAL)
		#pocket_ready.emit() 
	if((body.global_position.x <= global_position.x) && body is BaseBall): #check here so that only one plays the sound
		AudioManager.ball_hit()
	else:
		AudioManager.wall_hit()


func switch_type_dir(dir):
	if !shot_ready || change_anytime:
		return
	if dir == "l":
		if ball_type - 1 < 0:
			ball_type = available_types[available_types.size() - 1]
		else: 
			ball_type = available_types[ball_type - 1]
	else:
		if ball_type + 1 >= available_types.size():
			ball_type = available_types[0]
		else:
			ball_type = available_types[ball_type + 1]
	sprite.play(ball_sprite_list[ball_type])
	swapped_ball.emit()

func switch_type_spc(new_type: GlobalEnums.BallType):
	ball_type = new_type
	sprite.play(ball_sprite_list[ball_type])
	swapped_ball.emit()

func spawn_pocket():
	spawning_pocket.emit(global_position)

func spawn_explosion():
	var e = explosion_spawn.instantiate()
	e.global_position = global_position
	get_tree().current_scene.add_child(e)
	
func set_last_available():
	last_available_types = available_types.duplicate()
	
func set_starting_available():
	start_available_types = available_types.duplicate()
