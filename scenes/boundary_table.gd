extends Node2D



func pocketed_ball(body: Node2D):
	if body is BaseBall:
		body.queue_free()

func _on_tl_pocket_body_entered(body: Node2D) -> void:
	pocketed_ball(body)


func _on_bl_pocket_body_entered(body: Node2D) -> void:
	pocketed_ball(body)


func _on_br_pocket_body_entered(body: Node2D) -> void:
	pocketed_ball(body)


func _on_tr_pocket_body_entered(body: Node2D) -> void:
	pocketed_ball(body)


func _on_tc_pocket_body_entered(body: Node2D) -> void:
	pocketed_ball(body)


func _on_bc_pocket_body_entered(body: Node2D) -> void:
	pocketed_ball(body)
