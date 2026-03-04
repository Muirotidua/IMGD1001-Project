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
@onready var firstboundfirstkey: bool = false
@onready var firstboundsecondkey: bool = false
@onready var firstboundthirdkey: bool = false
@onready var firstboundfourthkey: bool = false
@onready var secondboundfirstkey: bool = false
@onready var secondboundsecondkey: bool = false
@onready var secondboundthirdkey: bool = false
@onready var secondboundfourthkey: bool = false


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
			await get_tree().create_timer(1).timeout
			second_wall_anim.play("unlock")
			await get_tree().create_timer(1.1).timeout
			second_wall_just_opened = true
	
	
func check_final():
	super.check_final()
	check_keys()
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
	if destination == GlobalEnums.Destination.NEXT:
		get_tree().change_scene_to_file("res://scenes/info-pages/credits.tscn")
	elif destination == GlobalEnums.Destination.LEVEL_SELECT:
		get_tree().change_scene_to_file("res://scenes/menus/level_select.tscn")
	else:
		LevelManager.menu_load = GlobalEnums.LoadAnim.SPECIAL
		get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
	
func check_keys():
	if ((pocket_track == 1) && !first_wall_anim.is_playing() && !firstboundfirstkey):
		first_wall_anim.play("pinkpocketed1")
		firstboundfirstkey = true
	if ((pocket_track == 2) && !first_wall_anim.is_playing() && !firstboundsecondkey):
		first_wall_anim.play("pinkpocketed2")
		firstboundsecondkey = true
	#if (pocket_track == 3):
		#first_wall_anim.play("pinkpocketed3")
	if ((pocket_track == 4)&& !second_wall_anim.is_playing() && !secondboundfirstkey):
		second_wall_anim.play("pinkpocketed1")
		secondboundfirstkey = true
	if ((pocket_track == 5)&&!second_wall_anim.is_playing() && !secondboundsecondkey):
		second_wall_anim.play("pinkpocketed2")
		secondboundsecondkey = true
	if ((pocket_track == 6)&&!second_wall_anim.is_playing() && !secondboundthirdkey):
		second_wall_anim.play("pinkpocketed3")
		secondboundthirdkey = true
	#if ((pocket_track == 7)&&!second_wall_anim.is_playing() && !secondboundfourthkey):
		#second_wall_anim.play("pinkpocketed4")
		#secondboundfourthkey = true
