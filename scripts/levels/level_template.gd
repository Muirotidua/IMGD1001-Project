#level_template.gd
class_name Level_template extends Node2D

enum State{ WON, LOST, PLAYING }

@export var shot_limit = 3
@export var two_star_limit = 2
@export var three_star_limit = 1
@export var level_id = 0

@onready var cue: CueBall = $CueBall
@onready var table: Node2D = $Other/Boundary_Table
@onready var pause: Node2D = $Menus/LevelPaused
@onready var lost: Node2D = $Menus/LevelLost
@onready var won: Node2D = $Menus/LevelWon
@onready var shot_display: Label = $Display/ShotCountDisplay
@onready var paused_button: Button = $Buttons/PausedButton
@onready var swap_ball: Control = $Menus/SwapBall
@onready var swap_ball_button: Button = $Buttons/SwapBallButton
@onready var swap_ball_button_sprite: AnimatedSprite2D = $Buttons/SwapBallButton/Sprite
@onready var star1: AnimatedSprite2D = $Display/Stars/Star1
@onready var star2: AnimatedSprite2D = $Display/Stars/Star2
@onready var star3: AnimatedSprite2D = $Display/Stars/Star3
@onready var tutorial: AnimatedSprite2D = $Display/Tutorial

var all_balls: Array[BaseBall] = []
var rewinded: bool = false
var state: State = State.PLAYING
var paused: bool = false
var fail_ready: bool = false
var star_count: int = 3

signal shoot()

func _ready():
	get_tree().paused = false
	table.pocketed_ball.connect(on_pocket)
	cue.try_shoot.connect(on_try_shoot)
	cue.swapped_ball.connect(update_swap_ball_sprite)
	pause.restart.connect(reset_table)
	pause.resume.connect(resume_play)
	lost.restart.connect(reset_table)
	lost.redo.connect(rewind_shot)
	won.restart.connect(reset_table)
	won.next_lev.connect(onward)
	shoot.connect(cue.on_shoot)
	swap_ball.swap_cue.connect(swap_cue_type)
	paused_button.pressed.connect(_on_paused_button_pressed)
	swap_ball_button.pressed.connect(_on_swap_ball_button_pressed)
	star1.play("full")
	star2.play("full")
	star3.play("full")
	if tutorial.sprite_frames.has_animation(str(level_id)):
		tutorial.show()
		tutorial.play(str(level_id))
	else:
		tutorial.hide()
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
	if Input.is_action_just_pressed("pause"):
		_on_paused_button_pressed()
	if !moving_balls():
		check_final() 
		cue.shot_ready = (state == State.PLAYING)
	elif !cue.rapid_fire:
		cue.shot_ready = false
	update_shot_display()
	

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
	tutorial.stop()
	tutorial.hide()
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
	state = State.PLAYING
	if cue.shot_count < three_star_limit:
		star_count = 3
		star1.play("full")
		star2.play("full")
		star3.play("full")
	elif cue.shot_count >= three_star_limit:
		star_count = 2
		star1.play("empty")
		star2.play("full")
		star3.play("full")
	if cue.shot_count >= two_star_limit:
		star_count = 1
		star1.play("empty")
		star2.play("empty")
		star3.play("full")
	

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
	star1.play("empty")
	star2.play("empty")
	star3.play("empty")
	get_tree().paused = true
	lost.visible = true

func win() -> void:
	# Unlock next level
	LevelManager.unlock_level(level_id + 1)
	LevelManager.set_stars(level_id, star_count)
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

func update_shot_display():
	if((shot_limit-cue.shot_count) == 1):
		shot_display.text = "1 shot left!!"
	else:
		shot_display.text = (str((shot_limit-cue.shot_count))+" shots left.")

func swap():
	get_tree().paused = true
	swap_ball.visible = true

func _on_swap_ball_button_pressed() -> void:
	if cue.shot_ready:
		swap()

func swap_cue_type(new_type: GlobalEnums.BallType):
	cue.switch_type_spc(new_type)
	
func update_swap_ball_sprite():
	swap_ball_button_sprite.play(cue.ball_sprite_list[cue.ball_type])
