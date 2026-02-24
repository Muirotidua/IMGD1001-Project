extends Node


@onready var music: AudioStreamPlayer = $Music

# having all of these as helper functions should make the in-script calls less complex, 
# and allow for intermediate steps between the call being made and playing the audio
# i will NOT be re-learning wwise for this project
func ball_hit():
	$BallHit.play()

func ball_break():
	$BallBreak.play()

func level_complete(_type: int): # based on number, hopefully can be set in script and be a single level complete call.
								 # should be 0 = fail, 1-3 = that many stars
	print(_type)
	$LevelComplete.play()

func wall_hit():
	print("wall hit")
	$WallHit.play()

func stick_hit():
	$StickHit.play()

func ball_sink(): #should randomize between the three available takes ideally. Important for this sound b/c it's crunchy
	$BallSink.play()
