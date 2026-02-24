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
var ball_type_list: Array[GlobalEnums.BallType] = [GlobalEnums.BallType.NORMAL, GlobalEnums.BallType.EXPLOSION, GlobalEnums.BallType.POCKET]
var ball_sprite_list: Array[String] = ["default", "explosion_ball", "default"] #change last default to be pocket ball sprite when added
var available_types: Array[GlobalEnums.BallType]
var available_sprites: Array[String]
var pocket_spawn = preload("res://scenes/ball-components/pocket.tscn")

@onready var shot_count = 0
@onready var count_label: Label = $NonRotate/CountLabel
@onready var pointer: Line2D = $PointerLine
@onready var pool_stick: PoolStick = $PoolStick

@onready var stick_pos: Vector2 = global_position

var shot_ready:bool  = true
var charging: bool = false

signal try_shoot()
signal swapped_ball()
signal pocket_ready()

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
	pool_stick._on_timer_timeout()
	super.reset()

func rewind():
	if !rewinded:
		shot_count -= 1
	rewinded = true
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
		switch_type_spc(GlobalEnums.BallType.NORMAL)
	if(ball_type == GlobalEnums.BallType.POCKET):
		var p = pocket_spawn.instantiate()
		p.global_position = global_position
		self.get_parent().add_child(p)
		pocket_ready.connect(p._pocket_ready)
		switch_type_spc(GlobalEnums.BallType.NORMAL)
		pocket_ready.emit() 
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
	sprite.play(available_sprites[ball_type])
	swapped_ball.emit()

func switch_type_spc(new_type: GlobalEnums.BallType):
	ball_type = new_type
	sprite.play(ball_sprite_list[ball_type])
	swapped_ball.emit()
