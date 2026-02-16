#level_template.gd
class_name Level_template extends Node2D

enum State{ WON, LOST, PLAYING }

@export var shot_limit = 3
@export var level_id = 0

@onready var table: Node2D = $Boundary_Table
@onready var cue: CueBall = $CueBall
@onready var pause: Node2D = $LevelPaused
@onready var lost: Node2D = $LevelLost
@onready var won: Node2D = $LevelWon

var all_balls: Array[BaseBall] = []
var rewinded: bool = false
var state: State = State.PLAYING
var paused: bool = false
var fail_ready: bool = false

signal shoot()

func _ready():
	get_tree().paused = false
	table.pocketed_ball.connect(on_pocket)
	cue.try_shoot.connect(on_try_shoot)
	pause.restart.connect(reset_table)
	pause.resume.connect(resume_play)
	lost.restart.connect(reset_table)
	lost.redo.connect(rewind_shot)
	won.restart.connect(reset_table)
	won.next_lev.connect(onward)
	shoot.connect(cue.on_shoot)
	for child: Node in get_children():
		if child is BaseBall:
			all_balls.append(child)


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset_table"):
		reset_table()
	if Input.is_action_just_pressed("rewind_shot"):
		rewind_shot()
	if Input.is_action_just_pressed("print_info"):
		print_info()
	if !moving_balls():
		check_final() 
		cue.shot_ready = (state == State.PLAYING)
	elif !cue.rapid_fire:
		cue.shot_ready = false
	

func on_pocket(ball, _pocket): 
	if ball is BaseBall:
		if !ball.ignore_pocket:
			ball.pocketing = true
	if ball is EightBall:
		is_eight_last_ball()

# 
func on_try_shoot(): # ?
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
	if paused:
		return
	fail_ready = false
	for ball: BaseBall in all_balls:
		ball.reset()
	lost.clear()
	won.clear()
		
func rewind_shot():
	if paused:
		return
	fail_ready = false
	for ball: BaseBall in all_balls:
		ball.rewind()
	lost.clear()
	won.clear()

func check_final():
	var pocket_count: int = 0
	if (cue.pocketed || cue.pocketing) || fail_ready:
		state = State.LOST
		lose()
		return
	for ball: BaseBall in all_balls:
		if ball is not CueBall && (ball.pocketed || ball.pocketing):
			pocket_count += 1
	# If all balls pocketed except for cueball
	if pocket_count == all_balls.size() - 1:
		state = State.WON
		win()
		return
	elif cue.shot_count >= shot_limit: #fuck you elif!!
		state = State.LOST
		lose()
		return
	else:
		state = State.PLAYING
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
	
	
		

func _on_paused_button_pressed() -> void:
	if state == State.PLAYING:
		get_tree().paused = true
		pause.visible = true
		paused = true


func lose() -> void:
	get_tree().paused = true
	lost.visible = true

func win() -> void:
	# Unlock next level
	LevelManager.unlock_level(level_id + 1)
	get_tree().paused = true
	won.visible = true

func onward() -> void:
	LevelManager.switch_level(level_id + 1)
	
func resume_play():
	paused = false

func is_eight_last_ball():
	var pocket_count: int = 0
	for ball: BaseBall in all_balls:
		if ball is not CueBall && ball is not EightBall && (ball.pocketed || ball.pocketing):
			pocket_count += 1
	if pocket_count != all_balls.size() - 2:
		fail_ready = true
