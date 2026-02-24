extends Level_template

func update_shot_display():
	
	shot_display.text = ("Shot " + str(cue.shot_count) + " | Best: " + (str(LevelManager.billiards_record) if LevelManager.billiards_record > 0 else "-"))

func check_final():
	var pocket_count: int = 0
	if (cue.pocketed || cue.pocketing) || fail_ready:
		state = State.LOST
		lose()
		return
	for ball: BaseBall in all_balls:
		if ball is not CueBall && (ball.pocketed || ball.pocketing):
			pocket_count += 1
	# If all balls pocketed except for cueball
	if pocket_count == all_balls.size() - 1:
		state = State.WON
		if cue.shot_count < LevelManager.billiards_record:
			LevelManager.billiards_record = cue.shot_count
		win()
		return
	state = State.PLAYING
