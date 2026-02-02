extends Node2D

@export var ball_path: NodePath

@onready var ball: RigidBody2D = get_node(ball_path)

func _process(delta):
	if ball != null:
		global_position = ball.global_position
