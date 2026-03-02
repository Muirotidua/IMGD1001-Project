class_name EightBall extends PoolBall

func _on_body_entered(body: Node) -> void:
	if((body.global_position.x <= global_position.x) && body is BaseBall): #check here so that only one plays the sound
		AudioManager.ball_hit(speed+body.speed)
	elif (!(body is BaseBall)):
		AudioManager.wall_hit(speed)
