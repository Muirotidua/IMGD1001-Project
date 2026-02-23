class_name Door extends StaticBody2D

@onready var anim = $AnimationPlayer
@export var active = true
var bol = true
func _physics_process(delta: float) -> void:
	if (active && bol):
		bol = false
		await get_tree().create_timer(3.0).timeout
		anim.play("boundary_unlocked")
		await get_tree().create_timer(3.0).timeout
		anim.play_backwards()
		await get_tree().create_timer(.50).timeout
		bol = true
