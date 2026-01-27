extends Area2D

@onready var mode_label: Label = $"../../UI/Mode"
@onready var pointer = $"../../Pointer"

@onready var shootSound = $"Bullet Shoot"

var manual: bool = false
var cooled: bool = false
var target: int = 0

func _ready():
	pointer.hide()
	
func _physics_process(_delta):
	if manual:
			look_at(get_global_mouse_position())
			if Input.is_action_pressed("shoot"):
				shoot()
	else:
		var enemies_in_range = get_overlapping_bodies()
		if enemies_in_range.size() > 0:
			if Input.is_action_just_pressed("left_tar"):
				target -= 1
			if Input.is_action_just_pressed("right_tar"):
				target += 1
			while target >= enemies_in_range.size():
				target -= 1
			if target < 0:
					target = enemies_in_range.size() - 1
			var target_enemy = enemies_in_range[target]
			look_at(target_enemy.global_position)
			pointer.global_position = target_enemy.global_position
			pointer.show()
			shoot()
		else:
			pointer.hide()
	if Input.is_action_just_pressed("switch"):
		manual = !manual
		if manual:
			mode_label.text = "Manual Mode"
			pointer.hide()
		else:
			mode_label.text = "Automatic Mode"

func shoot():
	if cooled:
		shootSound.play()
		const BULLET = preload("res://scenes/bullet.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation
		%ShootingPoint.add_child(new_bullet)
		cooled = false

func _on_timer_timeout() -> void:
	cooled = true
