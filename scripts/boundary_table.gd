extends Node2D

enum Pocket { TL, BL, TR, BR, TC, BC} 
	
signal pocketed_ball(body: Node2D, location)

func _on_tl_pocket_body_entered(body: Node2D) -> void:
	pocketed_ball.emit(body, Pocket.TL)


func _on_bl_pocket_body_entered(body: Node2D) -> void:
	pocketed_ball.emit(body, Pocket.BL)


func _on_br_pocket_body_entered(body: Node2D) -> void:
	pocketed_ball.emit(body, Pocket.BR)


func _on_tr_pocket_body_entered(body: Node2D) -> void:
	pocketed_ball.emit(body, Pocket.TR)


func _on_tc_pocket_body_entered(body: Node2D) -> void:
	pocketed_ball.emit(body, Pocket.TC)


func _on_bc_pocket_body_entered(body: Node2D) -> void:
	pocketed_ball.emit(body, Pocket.BC)
