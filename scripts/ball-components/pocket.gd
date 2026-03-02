extends Area2D
class_name Pocket

var active = false
var bodies = []
var pocket_ready = false
var tabled_last_shot = false
var contains_cue = false
var active_last = true
var just_rewinded = false

const rot_speed = 40
var pocketed_count = 0

signal remove(pocket: Pocket)
signal pocketed(ball: BaseBall, location)

func _ready():
	$Sprite2D.play()
	modulate = Color(0.2, 0.2, 0.2)

func _physics_process(_delta: float):
	if(pocket_ready):
		bodies = get_overlapping_bodies()
		contains_cue = false
		#print(active)
		#print(bodies)
		for ball in bodies:
			if (ball is CueBall) :
				contains_cue = true
			if (ball is BaseBall && active && !ball.counted && !ball.pocketed):
				pocketed.emit(ball, GlobalEnums.Pocket.SPAWNED)
		if just_rewinded:
			active = active_last
		elif(!contains_cue):
			# print(bodies)
			active = true
		
func _process(delta: float):
	if active:
		modulate = Color(1, 1, 1)
		$Sprite2D.rotation_degrees += rot_speed * delta
	else:
		modulate = Color(0.2, 0.2, 0.2)
		
func _pocket_ready():
	if(!pocket_ready):
		await get_tree().create_timer(.1).timeout
		pocket_ready = true

func rewind():
	just_rewinded = true
	if !tabled_last_shot:
		remove.emit(self)

func update():
	just_rewinded = false
	tabled_last_shot = true
	active_last = active
