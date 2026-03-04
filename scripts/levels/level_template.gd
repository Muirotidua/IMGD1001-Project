#level_template.gd
class_name Level_template extends Node2D

enum State{ WON, LOST, PLAYING }

@export var shot_limit = 3
@export var two_star_limit = 2
@export var three_star_limit = 1
@export var level_id = 0
@export var normal_available: bool = true
@export var explosion_available: bool = false
@export var pocket_available: bool = false
@export var show_arrow: bool = false

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
@onready var arrow: Node2D = $Display/Arrow
@onready var arrow_bounce: AnimationPlayer = $Display/Arrow/AnimationPlayer
@onready var arrow_anim: AnimatedSprite2D = $Display/Arrow/AnimatedSprite2D
@onready var cam: Camera2D = $Display/Camera2D
@onready var startup: Timer = $Other/Startup
@onready var sub: Timer = $Other/Substartup
@onready var lev_name: Label = $Display/LevelName

var pocket_spawn = preload("res://scenes/ball-components/pocket.tscn")
var all_balls: Array[BaseBall] = []
var rewinded: bool = false
var state: State = State.PLAYING
var paused: bool = false
var fail_ready: bool = false
var star_count: int = 3
var complete: bool = false
var pockets: Array[Pocket] = []
var pockets_shot_pocketed = 0
var start_explo_value : bool
var start_pock_value : bool
var swapping: bool = false
var pocket_track: int = 0
var starting = true
var began = false
var destination = GlobalEnums.Destination.LEVEL_SELECT

signal shoot()

func _ready():
	cam.make_current()
	sub.one_shot = true
	startup.one_shot = true
	star1.hide()
	star2.hide()
	star3.hide()
	lev_name.hide()
	shot_display.hide()
	swap_ball_button.hide()
	paused_button.hide()
	arrow.hide()
	startup.wait_time = 2
	sub.wait_time = 1.5
	startup.start()
	sub.start()
	table.show()
	cam.position.x = -2000
	var ctween = create_tween()
	ctween.set_ease(Tween.EASE_OUT)
	ctween.set_trans(Tween.TRANS_CUBIC)
	ctween.tween_property(cam, "position:x", 0, 1.5)
	swap_ball_button.focus_mode = Control.FOCUS_NONE
	paused_button.focus_mode = Control.FOCUS_NONE
	get_tree().paused = false
	swap_ball.swap_cue.connect(swap_cue_type)
	table.pocketed_ball.connect(on_pocket)
	cue.try_shoot.connect(on_try_shoot)
	cue.swapped_ball.connect(update_swap_ball_sprite)
	cue.spawning_pocket.connect(spawn_pocket)
	pause.restart.connect(reset_table)
	pause.resume.connect(resume_play)
	lost.restart.connect(reset_table)
	lost.redo.connect(rewind_shot)
	won.restart.connect(reset_table)
	won.transfer.connect(onward)
	lost.transfer.connect(onward)
	pause.transfer.connect(onward)
	shoot.connect(cue.on_shoot)
	if !swap_ball_button.pressed.is_connected(_on_swap_ball_button_pressed):
		swap_ball_button.pressed.connect(_on_swap_ball_button_pressed)
	if !paused_button.pressed.is_connected(_on_paused_button_pressed):
		paused_button.pressed.connect(_on_paused_button_pressed)
	if !startup.timeout.is_connected(_on_startup_timeout):
		startup.timeout.connect(_on_startup_timeout)
	if !sub.timeout.is_connected(_on_sub_timeout):
		sub.timeout.connect(_on_sub_timeout)
	update_swap_ball_sprite()
	star1.play("full")
	star2.play("full")
	star3.play("full")
	if normal_available:
		cue.available_types.append(GlobalEnums.BallType.NORMAL)
	if explosion_available:
		cue.available_types.append(GlobalEnums.BallType.EXPLOSION)
	if pocket_available:
		cue.available_types.append(GlobalEnums.BallType.POCKET)
	if cue.available_types.size() == 0:
		# Force at least 1 ball to exist
		cue.available_types.append(GlobalEnums.BallType.NORMAL)
	for i in range(GlobalEnums.BallType.size()):
		if cue.available_types.has(GlobalEnums.BallType.values()[i - 1]):
			LevelManager.type_discovered[i - 1] = true
			swap_ball.ball_availability[i - 1] = GlobalEnums.BallAvailability.AVAILABLE
		elif LevelManager.type_discovered[i - 1]:
			swap_ball.ball_availability[i - 1] = GlobalEnums.BallAvailability.UNAVAILABLE
	cue.switch_type_spc(cue.ball_type)
	swap_ball.color()
	if tutorial.sprite_frames.has_animation(str(level_id)):
		tutorial.show()
		tutorial.play(str(level_id))
	else:
		tutorial.hide()
	for child: Node in get_children():
		if child is BaseBall:
			all_balls.append(child)
		elif child is Pocket:
			pockets.append(child)
	await get_tree().create_timer(0.1).timeout
	start_explo_value = explosion_available
	start_pock_value = pocket_available
	update_shot_display()


func _physics_process(_delta: float) -> void:
	if starting:
		return
	if Input.is_action_just_pressed("reset_table"):
		reset_table()
	if Input.is_action_just_pressed("rewind_shot"):
		rewind_shot()
	if Input.is_action_just_pressed("print_info"):
		print_info()
	if Input.is_action_just_pressed("pause"):
		_on_paused_button_pressed()
	if Input.is_action_just_pressed("swap_ball"):
		_on_swap_ball_button_pressed()
	if !moving_balls():
		check_final() 
		cue.shot_ready = (state == State.PLAYING)
	elif !cue.rapid_fire:
		cue.shot_ready = false
	update_shot_display()

func on_pocket(ball, pocket): 
	if ball is BaseBall:
		if !ball.ignore_pocket && !ball.pocketed:
			ball.pocketing = true 
	if pocket == GlobalEnums.Pocket.SPAWNED && !ball.counted && ball.pocketing:
		ball.counted = true
		cue.shot_count -= 1
	if ball is EightBall:
		is_eight_last_ball()

# 
func on_try_shoot(): # ?
	if paused || swapping:
		return
	for ball: BaseBall in all_balls:
		ball.updateLastPos()
	for pocket: Pocket in pockets:
		pocket.update()
	hide_tutorials()
	shoot.emit()
	rewinded = false
	await get_tree().create_timer(0.1).timeout
	cue.spec_pock_last_shot = false

func hide_tutorials():
	tutorial.stop()
	tutorial.hide()

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
	# Iterate backwards as it modifies an array it reads
	for i in range(pockets.size() - 1, -1, -1):
		pockets[i].active = false
		pockets[i].remove.emit(pockets[i])
	for ball: BaseBall in all_balls:
		ball.reset()
	lost.clear()
	won.clear()
	complete = false
	await get_tree().create_timer(0.1).timeout
	explosion_available = start_explo_value
	pocket_available = start_pock_value
		
func rewind_shot():
	if paused:
		return
	rewinded = true
	fail_ready = false
	for i in range(pockets.size() - 1, -1, -1):
		pockets[i].active = false
		pockets[i].rewind()
	for ball: BaseBall in all_balls:
		ball.rewind()
	lost.clear()
	won.clear()
	complete = false

func check_final():
	var pocket_count: int = 0
	pocket_track = 0
	if (cue.pocketed || cue.pocketing) || fail_ready:
		state = State.LOST
		lose()
		return
	for ball: BaseBall in all_balls:
		if ball is not CueBall && (ball.pocketed || ball.pocketing):
			pocket_count += 1
			pocket_track += 1
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
	if ((shot_limit-cue.shot_count) < 2):
		explosion_available = false
	check_ball_availability()
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
	print("Total pocketed: " + str(pocket_track))
	print("-----------------------")
	
	
		

func _on_paused_button_pressed() -> void:
	AudioManager.ball_hit(1)
	if pause.visible:
		get_tree().paused = false
		pause.visible = false
		paused = false
		cue.pool_stick.unpaused()
	elif state == State.PLAYING && !paused:
		get_tree().paused = true
		pause.visible = true
		paused = true

func lose() -> void:
	star1.play("empty")
	star2.play("empty")
	star3.play("empty")
	if(!complete):
		AudioManager.complete_voice(0)
		complete = true
	get_tree().paused = true
	lost.visible = true

func win() -> void:
	# Unlock next level
	LevelManager.unlock_level(level_id + 1)
	LevelManager.set_stars(level_id, star_count)
	if(!complete):
		complete = true
		AudioManager.complete_voice(star_count)
	get_tree().paused = true
	won.visible = true

func onward(dest: GlobalEnums.Destination) -> void:
	destination = dest
	var newpos: Vector2
	if dest == GlobalEnums.Destination.NEXT:
		newpos = Vector2(2000, cam.position.y)
	elif dest == GlobalEnums.Destination.LEVEL_SELECT:
		newpos = Vector2(-2000, cam.position.y)
	else:
		newpos = Vector2(0, -1500)
	starting = true
	cue.shot_ready = false
	startup.start()
	AudioManager.pocket_off()
	var ctween = create_tween()
	ctween.set_ease(Tween.EASE_IN)
	ctween.set_trans(Tween.TRANS_CUBIC)
	ctween.tween_property(cam, "position", newpos, 2)
	
	
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
	if swapping:
		return
	swapping = true
	paused = true
	get_tree().paused = true
	swap_ball.visible = true 

func _on_swap_ball_button_pressed() -> void:
	AudioManager.ball_hit(1)
	if swapping:
		
		stop_swap()
	elif cue.shot_ready:
		swap()

func stop_swap():
	swapping = false
	get_tree().paused = false
	swap_ball.visible = false
	paused = false

func swap_cue_type(new_type: GlobalEnums.BallType):
	cue.switch_type_spc(new_type)
	stop_swap()
	
func update_swap_ball_sprite():
	arrow_anim.stop()
	arrow_bounce.stop()
	arrow.hide()
	swap_ball_button_sprite.play(cue.ball_sprite_list[cue.ball_type])

func spawn_pocket(pos: Vector2):
	var p = pocket_spawn.instantiate()
	p.global_position = pos
	get_tree().current_scene.add_child(p)
	p._pocket_ready()
	p.remove.connect(remove_pocket)
	p.pocketed.connect(on_pocket)
	pockets.append(p)

func remove_pocket(pocket: Pocket):
	if pockets.has(pocket):
		pockets.erase(pocket)
	pocket.queue_free()
	if pockets.is_empty():
		AudioManager.pocket_off()
	
func check_ball_availability():
	if (rewinded == true):
		return
	if (explosion_available && !cue.available_types.has(GlobalEnums.BallType.EXPLOSION)):
		cue.available_types.append(GlobalEnums.BallType.EXPLOSION)
		#cue.ball_sprite_list.insert(1, )
	if (pocket_available && !cue.available_types.has(GlobalEnums.BallType.POCKET)):
		cue.available_types.append(GlobalEnums.BallType.POCKET)
	if (!explosion_available && cue.available_types.has(GlobalEnums.BallType.EXPLOSION)):
		cue.available_types.remove_at(cue.available_types.find(GlobalEnums.BallType.EXPLOSION))
	if (!pocket_available && cue.available_types.has(GlobalEnums.BallType.POCKET)):
		cue.available_types.remove_at(cue.available_types.find(GlobalEnums.BallType.POCKET))
		
	for i in range(GlobalEnums.BallType.size()):
		if cue.available_types.has(GlobalEnums.BallType.values()[i - 1]):
			LevelManager.type_discovered[i - 1] = true
			swap_ball.ball_availability[i - 1] = GlobalEnums.BallAvailability.AVAILABLE
		elif LevelManager.type_discovered[i - 1]:
			swap_ball.ball_availability[i - 1] = GlobalEnums.BallAvailability.UNAVAILABLE
	swap_ball.color()

func _on_startup_timeout():
	if !began:
		starting = false
		began = true
		AudioManager.level_voice(level_id-1) #subtract 1 b/c 0 indexing
	else: 
		next()

func _on_sub_timeout():
	star1.position.x = -10
	star2.position.x = -10
	star3.position.x = -10
	lev_name.position.y = 1100
	shot_display.position.y = 1100
	swap_ball_button.position.y = 1100
	paused_button.position.y = -10
	arrow.position.x = -20
	star1.show() 
	star2.show()
	star3.show()
	lev_name.show()
	shot_display.show()
	swap_ball_button.show()
	paused_button.show()
	if show_arrow:
		arrow.show()
		arrow_anim.play("default")
		arrow_bounce.play("bounce")
	else:
		arrow.hide()
	var s1tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	var s2tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	var s3tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	var lntween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	var sdtween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	var sbtween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	var pbtween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	var atween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	s1tween.tween_property(star1, "position:x", 130, 0.5)
	s2tween.tween_property(star2, "position:x", 130, 0.5)
	s3tween.tween_property(star3, "position:x", 130, 0.5)
	lntween.tween_property(lev_name, "position:y", 940, 0.5)
	sdtween.tween_property(shot_display, "position:y", 910, 0.5)
	sbtween.tween_property(swap_ball_button, "position:y", 850, 0.5)
	pbtween.tween_property(paused_button, "position:y", 19, 0.5)
	atween.tween_property(arrow, "position:x", 140, 0.5)
	
func next():
	if destination == GlobalEnums.Destination.NEXT:
		LevelManager.switch_level(level_id + 1)
	elif destination == GlobalEnums.Destination.LEVEL_SELECT:
		get_tree().change_scene_to_file("res://scenes/menus/level_select.tscn")
	else:
		LevelManager.menu_load = GlobalEnums.LoadAnim.SPECIAL
		get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
	
