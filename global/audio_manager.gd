extends Node

const SPEED_MAX_VOLUME = 1000; # lowest speed for volume to be set to it's maximum (ball hit, wall hit)
const POWER_MAX_VOLUME = 50; # lowest shot power for valume to be set to it's maximum (stick hit)
const VOL_RANGE = 18; # volume range, placed from -(VOL_RANGE) to 0 db
var max_volume = 1

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

func setvol(newvol: float): #sets the volume of all audio players to the given value (between 0 and 1)
							#this is in godot's linear volume thing so it's confusing if you're used to db but
							#it's basically a float where 1 is 0db and 0 is silent and it's made to convert from a linear value into db
							#so the slider should be able to just send what percent full it is and be fine
	var players = self.get_children()
	max_volume = newvol
	for player: AudioStreamPlayer in players:
		player.volume_linear = newvol

func setsfxvol(newvol: float):
	
	var players = self.get_children()
	max_volume = newvol # only applies to sfx
	for player: AudioStreamPlayer in players:
		if(player.type == "SFX"):
			player.volume_linear = newvol

func setmusicvol(newvol: float):
	var players = self.get_children()
	for player: AudioStreamPlayer in players:
		if(player.type == "MUSIC"):
			player.volume_linear = newvol

func volmod(player: AudioStreamPlayer):
	var mod: float = rng.randf()*.1
	player.volume_linear -= mod

func ball_hit(speed):
	#$BallHit.volume_db = 0
	if(speed > SPEED_MAX_VOLUME): # clamp max speed (don't need to clamp in other direction since speed > 0
		speed = SPEED_MAX_VOLUME
	print(speed)
	var volume = speed/SPEED_MAX_VOLUME*max_volume
	print(volume)
	
	$BallHit.volume_linear = volume*max_volume
	print($BallHit.volume_db)
	volmod($BallHit)
	$BallHit.play()

func ball_break():
	$BallBreak.play()

func level_complete(_type: int): # based on number, hopefully can be set in script and be a single level complete call.
								 # should be 0 = fail, 1-3 = that many stars
	print(_type)
	$LevelComplete.stream = completesounds[_type]
	$LevelComplete.play()

func wall_hit(speed):
	if(speed > SPEED_MAX_VOLUME): # clamp max speed (don't need to clamp in other direction since speed > 0
		speed = SPEED_MAX_VOLUME
	print(speed)
	var volume = speed/SPEED_MAX_VOLUME*max_volume
	print(volume)
	
	$WallHit.volume_linear = volume
	volmod($WallHit)
	$WallHit.play()

func stick_hit(power):
	if(power > POWER_MAX_VOLUME): # clamp max speed (don't need to clamp in other direction since speed > 0
		power = POWER_MAX_VOLUME
	print(power)
	var volume = power/POWER_MAX_VOLUME*max_volume
	print(volume)
	
	$StickHit.volume_linear = volume
	volmod($StickHit)
	$StickHit.play()

func ball_sink(): #should randomize between the three available takes ideally. Important for this sound b/c it's crunchy
	var soundnum: int = rng.randi_range(0,2)
	$BallSink.stream = ballsinksounds[soundnum]
	$BallSink.play()
	
func pocket_drone():
	if(!$Pocket.playing):
		$Pocket.play()

func explosion():
	$Explosion.play()
