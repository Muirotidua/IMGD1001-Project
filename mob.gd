extends CharacterBody2D

const MAX_HP = 3
var health = MAX_HP

@onready var player = get_node("/root/Game/Player")
@onready var game = get_node("/root/Game")
@onready var kill_counter = get_node("/root/Game/UI/Kills")

func _ready():
	%Slime.play_walk()

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 300.0
	move_and_slide()

func take_damage():
	health -= 1
	%Slime.play_hurt()
	if health == 0:
		queue_free()
		game.kills += 1
		if game.kills == 1:
			kill_counter.text = "1 Kill"
		else:
			kill_counter.text = str(game.kills) + " Kills" 
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
