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
@onready var firstboundfirstkey_just_activated: bool = false
@onready var firstboundsecondkey_just_activated: bool = false
@onready var firstboundthirdkey_just_activated: bool = false
@onready var firstboundfourthkey_just_activated: bool = false
@onready var secondboundfirstkey_just_activated: bool = false
@onready var secondboundsecondkey_just_activated: bool = false
@onready var secondboundthirdkey_just_activated: bool = false
@onready var secondboundfourthkey_just_activated: bool = false


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
			first_wall_just_opened = true
			first_wall_anim.play("unlock")
			await get_tree().create_timer(1.1).timeout
			
			#first_is_unlocking = false
				
			
	if !(second_wall_has_opened):
		if (pocket_track == 7):
			second_wall_has_opened = true
			explosion_available = false
			second_wall_just_opened = true
			await get_tree().create_timer(0.5).timeout
			second_wall_anim.play("unlock")
			#await get_tree().create_timer(1.1).timeout
	
	
func check_final():
	super.check_final()
	check_keys()
	if (pocket_track == 3) || (pocket_track == 7):
		open_boundary()
	check_keys()
	
func on_try_shoot():
	super.on_try_shoot()
	if (first_wall_just_opened):
		first_wall_just_opened = false
	if (second_wall_just_opened):
		second_wall_just_opened = false
	if (firstboundfirstkey_just_activated):
		firstboundfirstkey_just_activated = false
	if (firstboundsecondkey_just_activated):
		firstboundsecondkey_just_activated = false
	if (firstboundthirdkey_just_activated):
		firstboundthirdkey_just_activated = false
	if (secondboundfirstkey_just_activated):
		secondboundfirstkey_just_activated = false
	if (secondboundsecondkey_just_activated):
		secondboundsecondkey_just_activated = false
	if (secondboundthirdkey_just_activated):
		secondboundthirdkey_just_activated = false
	if (secondboundfourthkey_just_activated):
		secondboundfourthkey_just_activated = false 

func rewind_shot():
	super.rewind_shot()
	await get_tree().create_timer(0.1).timeout
	if (first_wall_just_opened):
		print ("UNLOCKING 1ST")
		first_wall_anim.stop()
		first_wall_anim.play("RESET")
		first_wall_anim.advance(0)
		first_wall_just_opened = false
		first_wall_has_opened = false
	
	#if (pocket_track > 0):
		#first_wall_anim.play("pinkpocketed1")
		
	#if (pocket_track > 1):
		#first_wall_anim.play("pinkpocketed1")
		#await get_tree().create_timer(1).timeout
		#first_wall_anim.play("pinkpocketed2")
	if (second_wall_just_opened):
		print ("UNLOCKING 2ND")
		second_wall_anim.stop()
		second_wall_anim.play("RESET")
		second_wall_anim.advance(0)
		second_wall_just_opened = false
		second_wall_has_opened = false
	if (pocket_track > 3):
		second_wall_anim.play("pinkpocketed1")
	if (pocket_track > 4):
		second_wall_anim.play("pinkpocketed2")
	if (pocket_track > 5):
		second_wall_anim.play("pinkpocketed3")
	#first_wall_anim.stop()
	#first_wall_anim.seek(0,true)
	#second_wall_anim.stop()
	#second_wall_anim.seek(0,true)
	if (first_wall_anim.is_playing()) || (firstboundfirstkey_just_activated):
		first_wall_anim.stop()
		first_wall_anim.play("RESET")
		first_wall_anim.advance(0)
		firstboundfirstkey = false
		firstboundfirstkey_just_activated = false
	if (first_wall_anim.is_playing()) || (firstboundsecondkey_just_activated):
		first_wall_anim.stop()
		first_wall_anim.play("RESET")
		first_wall_anim.advance(0)
		firstboundsecondkey = false
		firstboundsecondkey_just_activated = false
		
	#check_keys()
	if (first_wall_anim.is_playing()) || (firstboundthirdkey_just_activated):
		first_wall_anim.stop()
		first_wall_anim.play("RESET")
		first_wall_anim.advance(0)
		firstboundthirdkey = false
		firstboundthirdkey_just_activated = false
	#check_keys()
	if (secondboundfirstkey_just_activated):
		second_wall_anim.stop()
		second_wall_anim.play("RESET")
		second_wall_anim.advance(0)
		secondboundfirstkey = false
		secondboundfirstkey_just_activated = false
		
	#check_keys()
	if (secondboundsecondkey_just_activated):
		second_wall_anim.stop()
		second_wall_anim.play("RESET")
		second_wall_anim.advance(0)
		secondboundsecondkey = false
		secondboundsecondkey_just_activated = false
		second_wall_anim.play("pinkpocketed1")
	#check_keys()
	if (secondboundthirdkey_just_activated):
		second_wall_anim.stop()
		second_wall_anim.play("RESET")
		second_wall_anim.advance(0)
		secondboundthirdkey = false
		secondboundthirdkey_just_activated = false
		second_wall_anim.play("pinkpocketed1")
		await get_tree().create_timer(0.6).timeout
		second_wall_anim.play("pinkpocketed2")
	#check_keys()
	if (secondboundfourthkey_just_activated):
		second_wall_anim.stop()
		second_wall_anim.play("RESET")
		second_wall_anim.advance(0)
		secondboundfourthkey = false
		secondboundfourthkey_just_activated = false
		second_wall_anim.play("pinkpocketed1")
		await get_tree().create_timer(0.6).timeout
		second_wall_anim.play("pinkpocketed2")
		await get_tree().create_timer(0.6).timeout
		second_wall_anim.play("pinkpocketed3")
	check_keys()

		
func reset_table():
	first_wall_anim.play("RESET")
	first_wall_anim.advance(0)
	first_wall_has_opened = false
	first_wall_just_opened = false
	second_wall_anim.play("RESET")
	second_wall_anim.advance(0)
	second_wall_has_opened = false
	second_wall_just_opened = false
	firstboundfirstkey = false
	firstboundsecondkey = false
	firstboundthirdkey = false
	firstboundfourthkey = false
	secondboundfirstkey = false
	secondboundsecondkey = false
	secondboundthirdkey = false
	secondboundfourthkey = false
	
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
	if ((pocket_track >= 1) && !first_wall_anim.is_playing() && !firstboundfirstkey):
		first_wall_anim.play("pinkpocketed1")
		AudioManager.power_on()
		firstboundfirstkey = true
		firstboundfirstkey_just_activated = true
	if ((pocket_track >= 2) && !first_wall_anim.is_playing() && !firstboundsecondkey):
		first_wall_anim.play("pinkpocketed2")
		AudioManager.power_on()
		firstboundsecondkey = true
		firstboundsecondkey_just_activated = true
	if (pocket_track >= 3) && !first_wall_anim.is_playing() && !firstboundthirdkey:
		first_wall_anim.play("unlock")
		AudioManager.power_on()
		firstboundthirdkey= true
		firstboundthirdkey_just_activated = true
	if ((pocket_track >= 4)&& !second_wall_anim.is_playing() && !secondboundfirstkey):
		second_wall_anim.play("pinkpocketed1")
		AudioManager.power_on()
		secondboundfirstkey = true
		secondboundfirstkey_just_activated = true
	if ((pocket_track >= 5)&& !second_wall_anim.is_playing() && !secondboundsecondkey):
		second_wall_anim.play("pinkpocketed2")
		AudioManager.power_on()
		secondboundsecondkey = true
		secondboundsecondkey_just_activated = true
	if ((pocket_track >= 6)&& !second_wall_anim.is_playing() && !secondboundthirdkey):
		second_wall_anim.play("pinkpocketed3")
		AudioManager.power_on()
		secondboundthirdkey = true
		secondboundthirdkey_just_activated = true
	if ((pocket_track == 7)&&!second_wall_anim.is_playing() && !secondboundfourthkey):
		second_wall_anim.play("unlock")
		AudioManager.power_on()
		secondboundfourthkey = true
		secondboundfourthkey_just_activated = true
