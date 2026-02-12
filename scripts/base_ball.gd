class_name BaseBall extends RigidBody2D

@export var sprite_path: NodePath
@export var debug_labels: bool = false

@onready var motion_label: Label = $NonRotate/MotionLabel
@onready var speed_label: Label = $NonRotate/SpeedLabel
@onready var sprite: AnimatedSprite2D = get_node(sprite_path)

const DEFAULT_SCALE: Vector2 = Vector2(0.06, 0.06)

var inmotion: bool = false
var speed: float = 0.0

var pocketing: bool = false
var pocketed: bool = false
var tabled_last_shot: bool = true
var ignore_pocket: bool = false

var def_state: String = "default"
var state: String = "default"
var type: GlobalEnums.BallType = GlobalEnums.BallType.GENERIC_BALL

@onready var last_pos: Vector2 = global_position
@onready var def_pos: Vector2 = global_position


func _ready():
	sprite.set_scale(DEFAULT_SCALE)
	if debug_labels:
		speed_label.show()
		motion_label.show()
	else:
		speed_label.hide()
		motion_label.hide()


func _physics_process(delta: float) -> void:
	ignore_pocket = false
	speed = abs(linear_velocity.length())
	$NonRotate.global_rotation = 0.0
	if debug_labels:
		speed_label.text = str(speed)
	if speed < 10:
		linear_damp = 50
		if speed < 1:
			linear_damp = 1
			linear_velocity = Vector2.ZERO
			inmotion = false
			motion_label.text = "FALSE"
	else:
		inmotion = true
		motion_label.text = "TRUE"
	if pocketing:
		linear_damp = 50
		sprite.set_scale(sprite.get_scale() - Vector2(0.2, 0.2) * delta)
		linear_damp = 1000 ##if this causes any problems
		if sprite.scale.length() <= 0.01:
			pocket()


func pocket():
	inmotion = false
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	pocketing = false
	pocketed = true
	hide()
	sprite.set_scale(DEFAULT_SCALE)
	collision_layer = 0
	collision_mask = 0

func unpocket():
	pocketed = false
	pocketing = false
	tabled_last_shot = true
	ignore_pocket = false
	show()
	collision_layer = 0
	collision_mask = 0
	linear_damp = 1

func rewind():
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	if pocketing:
		pocket()
	if pocketed:
		if tabled_last_shot:
			unpocket()
			teleport(last_pos)
			call_deferred("teleport", last_pos)
	else:
		call_deferred("teleport", last_pos)

	
func reset():
	if pocketing:
		pocket()
	if pocketed:
		unpocket()
	tabled_last_shot = true
	pocketing = false
	pocketed = false
	last_pos = def_pos
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	teleport(last_pos)
	call_deferred("teleport", def_pos)

func updateLastPos():
	if !pocketed && !pocketing:
		last_pos = global_position
		tabled_last_shot = true
	else: 
		tabled_last_shot = false
		
func teleport(pos: Vector2):
	freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
	freeze = true
	collision_layer = 0
	collision_mask = 0
	global_position = pos
	print("Ball moved to position at            %d,%d" % [global_position.x, global_position.y]) 
	call_deferred("enable_collisions")
	
func enable_collisions():
	freeze = false
	collision_layer = 1
	collision_mask = 1
	sleeping = true
