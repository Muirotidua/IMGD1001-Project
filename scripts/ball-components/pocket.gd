extends Area2D
class_name Pocket

var active = false
var bodies = []
var pocket_ready = false

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
		
func _pocket_ready():
	if(!pocket_ready):
		await get_tree().create_timer(.1).timeout
		pocket_ready = true
