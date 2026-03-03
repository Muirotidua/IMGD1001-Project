extends Level_template

@onready var first_wall = $AnimWallObstacle
@onready var first_wall_anim = $AnimWallObstacle/AnimationPlayer
@onready var second_wall = $SecondAnimWallObstacle2
@onready var second_wall_anim = $SecondAnimWallObstacle2/AnimationPlayer
@onready var balls_pocketed: int = 0
@onready var balls_recent_pocketed: int = 0
@onready var first_wall_just_opened: bool = false
@onready var second_wall_just_opened: bool = false
@onready var first_wall_has_opened: bool = false
@onready var second_wall_has_opened: bool = false
#@onready var first_is_unlocking: bool = false
#@onready var second_is_unlocking: bool = false

func _ready():
	super._ready()
	explosion_available = false

func _physics_process(_delta: float) -> void:
	super._physics_process(_delta)
	if (pocket_track > 2):
		explosion_available = true
	if (pocket_track > 6):
		explosion_available = false
	print("Explo Status:", explosion_available)

func open_boundary():
	if !(first_wall_has_opened):
		if (pocket_track == 3):
			first_wall_has_opened = true
			pocket_available = false
			explosion_available = true
			print (explosion_available)
			print("Explosion is true")
			print(pocket_track)
			#if !(first_wall_anim.is_playing()):
			#first_is_unlocking = true
			first_wall_anim.play("unlock")
			await get_tree().create_timer(1.1).timeout
			first_wall_just_opened = true
			#first_is_unlocking = false
				
			
	if !(second_wall_has_opened):
		print(pocket_track)
		if (pocket_track == 7):
			second_wall_has_opened = true
			explosion_available = false
			print(pocket_track)
			second_wall_anim.play("unlock")
			await get_tree().create_timer(1.1).timeout
			second_wall_just_opened = true
	
	
func check_final():
	super.check_final()
	if (pocket_track == 3) || (pocket_track == 7):
		open_boundary()
	
func on_try_shoot():
	super.on_try_shoot()
	if (first_wall_just_opened):
		first_wall_just_opened = false
	if (second_wall_just_opened):
		second_wall_just_opened = false

func rewind_shot():
	super.rewind_shot()
	await get_tree().create_timer(0.1).timeout
	if (first_wall_anim.is_playing()) || (first_wall_just_opened):
		print ("UNLOCKING 1ST")
		first_wall_anim.stop()
		first_wall_anim.play("RESET")
		first_wall_anim.advance(0)
		first_wall_has_opened = false
		first_wall_just_opened = false
	if (second_wall_anim.is_playing()) || (second_wall_just_opened):
		print ("UNLOCKING 2ND")
		second_wall_anim.stop()
		second_wall_anim.play("RESET")
		second_wall_anim.advance(0)
		second_wall_has_opened = false
		second_wall_just_opened = false

		
func reset_table():
	first_wall_anim.play("RESET")
	first_wall_anim.advance(0)
	first_wall_has_opened = false
	first_wall_just_opened = false
	second_wall_anim.play("RESET")
	second_wall_anim.advance(0)
	second_wall_has_opened = false
	second_wall_just_opened = false
	super.reset_table()
	
func next() -> void:
	get_tree().change_scene_to_file("res://scenes/info-pages/credits.tscn")
