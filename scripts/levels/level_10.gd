extends Level_template

@onready var first_wall = $WallObstacle
@onready var first_wall_anim = $WallObstacle/AnimationPlayer
@onready var second_wall = $WallObstacle2
@onready var second_wall_anim = $WallObstacle2/AnimationPlayer
@onready var balls_pocketed: int = 0
@onready var balls_recent_pocketed: int = 0
@onready var first_wall_just_opened: bool = false
@onready var second_wall_just_opened: bool = false


func open_boundary():
	if !(first_wall_just_opened) || !(second_wall_just_opened):
		if (pocket_track > 2):
			print(pocket_track)
			if !(first_wall_anim.is_playing()):
				first_wall_anim.play("Unlock")
				await get_tree().create_timer(1.1).timeout
				first_wall_just_opened = true
			
		if (pocket_track > 6):
			print(pocket_track)
			second_wall_anim.play("unlock")
			await get_tree().create_timer(1.1).timeout
			second_wall_just_opened = true
	
	
func check_final():
	super.check_final()
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
	if (first_wall_just_opened):
		first_wall_anim.play("RESET")
		first_wall_anim.advance(0)
		first_wall.visible = true
	if (second_wall_just_opened):
		second_wall_anim.play("RESET")
		second_wall_anim.advance(0)
		second_wall.visible = true

		
func reset_table():
	first_wall_anim.play("RESET")
	first_wall_anim.advance(0)
	first_wall.visible = true
	second_wall_anim.play("RESET")
	second_wall_anim.advance(0)
	second_wall.visible = true
	super.reset_table()
	
	
		
	
