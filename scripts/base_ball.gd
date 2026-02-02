class_name BaseBall extends RigidBody2D

@export var debug_label_path: NodePath
@export var debug_labels: bool = false


@onready var motion_label: Label = get_node(debug_label_path).get_node("MotionLabel")
@onready var speed_label: Label = get_node(debug_label_path).get_node("SpeedLabel")

var inmotion: bool = false
var speed

func _ready():
	if debug_labels:
		speed_label.show()
		motion_label.show()
	else: 
		speed_label.hide()
		motion_label.hide()
		
	
func _physics_process(delta: float) -> void:
	speed = abs(linear_velocity.length())
	speed_label.text = str(speed)
	if speed < 10:
		linear_damp = 50
		if speed < 1:
			linear_damp = 1
			inmotion = false
			motion_label.text = "FALSE"
			
	else:
		inmotion = true
		motion_label.text = "TRUE"
