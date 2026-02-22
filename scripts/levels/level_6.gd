extends Level_template

@onready var boundary = $BoundaryObstacle
@onready var unlock = $BoundaryUnlock
@onready var bound_colorrect = $BoundaryObstacle/ColorRect
@onready var unlock_colorrect = $BoundaryUnlock/ColorRect
@onready var anim_unlock = $BoundaryUnlock/AnimationPlayer
@onready var anim_bound = $BoundaryObstacle/AnimationPlayer
@onready var unlock_size = $BoundaryUnlock/CollisionShape2D.shape.size.x
@onready var bound_size = $BoundaryObstacle/CollisionShape2D.shape.size.y

func _on_area_2d_body_entered(body: BaseBall) -> void:
	unlock_colorrect.color = Color("1cc100de")
	bound_colorrect.color = Color("00ebff")
	anim_unlock.play("boundary_pressed")
	anim_bound.play("boundary_unlocked")
	await get_tree().create_timer(1.0).timeout
	boundary.queue_free()
	unlock.queue_free()
	
