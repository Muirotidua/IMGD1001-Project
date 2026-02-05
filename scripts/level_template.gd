#level_template.gd
class_name Level_template extends Node2D

enum State{ WON, LOST, PLAYING }

@export var shot_limit = 3
@export var cue_path: NodePath

@onready var table: Node2D = $Boundary_Table
@onready var cue: CueBall = get_node(cue_path)
@onready var win_text: Label = $WinText

var all_balls: Array[BaseBall] = []
var rewinded: bool = false
var state: State = State.PLAYING

signal shoot()
signal finished_game_check();

func _ready():
	table.pocketed_ball.connect(on_pocket)
	cue.try_shoot.connect(on_try_shoot)
	shoot.connect(cue.on_shoot)
	for child: Node in get_children():
		if child is BaseBall:
			all_balls.append(child)


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("reset_table"):
		reset_table()
	if Input.is_action_just_pressed("rewind_shot"):
		rewind_shot()
	if Input.is_action_just_pressed("print_info"):
		print_info()
	if !moving_balls():
		check_final() 
		cue.shot_ready = (state == State.PLAYING)
	else:
		cue.shot_ready = false
	

func on_pocket(ball, _pocket): 
	if ball is BaseBall:
		if !ball.ignore_pocket:
			ball.pocketing = true

# 
func on_try_shoot(): # ?
	if !cue.shot_ready && !cue.infinite_shots:
		return
	for ball: BaseBall in all_balls:
		ball.updateLastPos()
	shoot.emit()
		

# False if no balls are moving. True otherwise
func moving_balls() -> bool: # ??? Need to ensure that this is looking at the cue ball moving, ask Liam when he's back.
	for ball: BaseBall in all_balls:
		if ball.inmotion && !ball.pocketed:
			return true
	return false

func reset_table():
	for ball: BaseBall in all_balls:
		ball.reset()
		
func rewind_shot():
	for ball: BaseBall in all_balls:
		ball.rewind()

func check_final():
	var pocket_count: int = 0
	if (cue.pocketed || cue.pocketing):
		state = State.LOST
		win_text.text = "Failure."
		return
	for ball: BaseBall in all_balls:
		if ball is not CueBall && (ball.pocketed || ball.pocketing):
			pocket_count += 1
		#if ball is not CueBall && !ball.pocketed && !ball.pocketing:
			#state = State.PLAYING
			#win_text.text = ""
			#return
	if pocket_count == all_balls.size()-1:
		state = State.WON
		win_text.text = "Victory!"
		return
	elif cue.shot_count>=shot_limit: #fuck you elif!!
		state = State.LOST
		win_text.text = "Failure."
		return
	else:
		state = State.PLAYING
		win_text.text = ""
		return

func print_info():
	print("-----------------------")
	for ball: BaseBall in all_balls:
		if ball is CueBall:
			print("Cue Ball")
		elif ball is EightBall:
			print("Eight Ball")
		else:
			print("Unknown Ball")
		if ball.pocketed:
			print("\tBall is pocketed")
		if ball.pocketing:
			print("\tBall is pocketing")
		if !ball.pocketing && !ball.pocketed:
			print("\tBall is tabled")
		if ball.inmotion:
			print("\tBall is in motion")
		if ball.tabled_last_shot:
			print("\tBall was tabled last shot")
	print("-----------------------")
