extends Area2D
class_name Pocket

var active = false
var bodies = []
var pocket_ready = false
var tabled_last_shot = false
const rot_speed = 40

signal remove(pocket: Pocket)

func _ready():
	$Sprite2D.play()
	modulate = Color(0.2, 0.2, 0.2)

func _physics_process(_delta: float):
	if(pocket_ready):
		bodies = get_overlapping_bodies()
		var contains_cue = false
		print(active)
		print(bodies)
		
		for ball in bodies:
			if (ball is CueBall):
				contains_cue = true
			if (ball is BaseBall && active):
				ball.pocketing = true
		if(!contains_cue):
			# print(bodies)
			active = true
			modulate = Color(1, 1, 1)
		
func _process(delta: float):
	if active:
		$Sprite2D.rotation_degrees += rot_speed * delta
		
func _pocket_ready():
	if(!pocket_ready):
		await get_tree().create_timer(.1).timeout
		pocket_ready = true

func rewind():
	if !tabled_last_shot:
		remove.emit(self)
