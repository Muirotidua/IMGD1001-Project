extends Node2D

@onready var time_label: Label = $UI/Time

var time: int = 0
var kills: int = 0

func _ready():
	$Fade.show()
	$Fade/AnimationPlayer.play("fade_out_black")
	spawn_mob()
	spawn_mob()
	spawn_mob()
	spawn_mob()
	spawn_mob()

func spawn_mob():
	var new_mob = preload("res://scenes/mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)

func _on_timer_timeout() -> void:
	spawn_mob()

func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true

func _on_counter_timeout() -> void:
	time += 1
	var sec = int(time % 60)
	var mins = int(time / 60)
	if mins < 60:
		time_label.text = "%02d:%02d" % [mins, sec]
	else:
		time_label.text = "You Win!"
