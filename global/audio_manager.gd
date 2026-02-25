extends Node


@onready var music: AudioStreamPlayer = $Music
var fail = preload("res://sounds/sfx/level-fail.wav")
var onestar = preload("res://sounds/sfx/level-one-star.wav")
var twostar = preload("res://sounds/sfx/level-two-star.wav")
var threestar = preload("res://sounds/sfx/level-three-star.wav")
var completesounds = [fail,onestar,twostar,threestar]

var rng = RandomNumberGenerator.new()
var ballsinksounds = [preload("res://sounds/sfx/ball-sink-1.wav"),preload("res://sounds/sfx/ball-sink-2.wav"),preload("res://sounds/sfx/ball-sink-3.wav")]

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
	$LevelComplete.stream = completesounds[_type]
	$LevelComplete.play()

func wall_hit():
	$WallHit.play()

func stick_hit():
	$StickHit.play()

func ball_sink(): #should randomize between the three available takes ideally. Important for this sound b/c it's crunchy
	var soundnum: int = rng.randi_range(0,2)
	$BallSink.stream = ballsinksounds[soundnum]
	$BallSink.play()
