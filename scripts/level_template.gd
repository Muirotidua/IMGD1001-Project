extends Node2D

var tabled_balls: Array[BaseBall] = []
var pocketed_balls: Array[BaseBall] = []

func _ready():
	var table = $Boundary_Table
	table.pocketed_ball.connect(on_pocket)
	for child: Node in get_children():
		if child is BaseBall:
			tabled_balls.append(child)
			

func on_pocket(ball, pocket):
	if ball is BaseBall:
		ball.pocketing = true
		if ball is CueBall:
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		elif ball is EightBall:
			tabled_balls.erase(ball)
			pocketed_balls.append(ball)
			get_tree().change_scene_to_file("res://scenes/splash_screen.tscn")
		
