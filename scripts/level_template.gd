#level_template.gd
extends Node2D


@onready var table: Node2D = $Boundary_Table
@onready var cue: CueBall = $CueBall

var tabled_balls: Array[BaseBall] = []
var pocketed_balls: Array[BaseBall] = []
var queue: Array[BaseBall] = []
var rewinded: bool = false

signal shoot()

func _ready():
	table.pocketed_ball.connect(on_pocket)
	cue.try_shoot.connect(on_try_shoot)
	shoot.connect(cue.on_shoot)
	for child: Node in get_children():
		if child is BaseBall:
			tabled_balls.append(child)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset_table"):
		reset_table()
	if Input.is_action_just_pressed("rewind_shot"):
		rewind_shot()
	if !moving_balls():
		cue.shot_ready = true
	else:
		cue.shot_ready = false

func on_pocket(ball, _pocket):
	if ball is BaseBall:
		ball.pocketing = true
		if ball is CueBall:
			print("Lose")
		elif ball is EightBall:
			tabled_balls.erase(ball)
			pocketed_balls.append(ball)
			print("Win")


func on_try_shoot():
	if !moving_balls() || cue.infinite_shots:
		for ball: BaseBall in tabled_balls:
			ball.updateLastPos()
		for ball: BaseBall in pocketed_balls:
			ball.updateLastPos()
		shoot.emit()
		

func moving_balls() -> bool:
	var moving = false
	for ball: BaseBall in tabled_balls:
		if ball.inmotion:
			moving = true
	return moving

func reset_table():
	for ball: BaseBall in tabled_balls:
		ball.reset()
	for ball: BaseBall in pocketed_balls:
		ball.reset()
		queue.append(ball)
		tabled_balls.append(ball)
	for ball: BaseBall in queue:
		pocketed_balls.erase(ball)
	queue.clear()
		
func rewind_shot():
	for ball: BaseBall in tabled_balls:
		ball.rewind()
	for ball: BaseBall in pocketed_balls:
		ball.rewind()
