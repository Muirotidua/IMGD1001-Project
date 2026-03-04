extends Node

const SPEED_MAX_VOLUME = 1000; # lowest speed for volume to be set to it's maximum (ball hit, wall hit)
const POWER_MAX_VOLUME = 50; # lowest shot power for valume to be set to it's maximum (stick hit)
const VOL_RANGE = 18; # volume range, placed from -(VOL_RANGE) to 0 db
var max_volume = .5
var max_sfx_volume = .5
var max_music_volume = .5
var max_voice_volume = .5

@onready var music: AudioStreamPlayer = $Music
var fail = preload("res://sounds/sfx/level-fail.wav")
var onestar = preload("res://sounds/sfx/level-one-star.wav")
var twostar = preload("res://sounds/sfx/level-two-star.wav")
var threestar = preload("res://sounds/sfx/level-three-star.wav")
var instrumentcompletesounds = [fail,onestar,twostar,threestar]
var failvoice = [preload("res://sounds/sfx/VoiceLines/E_Womp_Womp.wav"),preload("res://sounds/sfx/VoiceLines/Liam_I_Hate_You.wav"),preload("res://sounds/sfx/VoiceLines/Eric_Boo.wav")]
var onestarvoice =[preload("res://sounds/sfx/VoiceLines/E_You_Rock.wav"),preload("res://sounds/sfx/VoiceLines/Liam_Wohoo_Warble.wav"),preload("res://sounds/sfx/VoiceLines/Eric_Woo.wav")]
var twostarvoice = [preload("res://sounds/sfx/VoiceLines/E_Wohoo.wav"),preload("res://sounds/sfx/VoiceLines/Liam_Yessir.wav"),preload("res://sounds/sfx/VoiceLines/Eric_Lets_Go.wav")]
var threestarvoice = [preload("res://sounds/sfx/VoiceLines/E_Hell_Yeah.wav"),preload("res://sounds/sfx/VoiceLines/Liam_You_Did_It.wav"),preload("res://sounds/sfx/VoiceLines/Eric_Cheer_Clap.wav")]
var secretvoice = [preload("res://sounds/sfx/VoiceLines/Liam_ILY.wav"),preload("res://sounds/sfx/VoiceLines/Eric_Blooper.wav"),preload("res://sounds/sfx/VoiceLines/E_Hell_Yeah_Pitched.wav")]
var voicecompletesounds = [failvoice,onestarvoice,twostarvoice,threestarvoice]

var rng = RandomNumberGenerator.new()
var ballsinksounds = [preload("res://sounds/sfx/ball-sink-1.wav"),preload("res://sounds/sfx/ball-sink-2.wav"),preload("res://sounds/sfx/ball-sink-3.wav")]
var levelstartsounds = [preload("res://sounds/sfx/VoiceLines/The_First_One.wav"),preload("res://sounds/sfx/VoiceLines/Three's_Company.wav"),preload("res://sounds/sfx/VoiceLines/Dodging_Walls.wav"),preload("res://sounds/sfx/VoiceLines/Kaboom.wav"),preload("res://sounds/sfx/VoiceLines/Bomb's_Away.wav"),preload("res://sounds/sfx/VoiceLines/Open_Sesame.wav"),preload("res://sounds/sfx/VoiceLines/No_Way_Out.wav"),preload("res://sounds/sfx/VoiceLines/Back_And_Better.wav"),preload("res://sounds/sfx/VoiceLines/Chaotic_Playground.wav"),preload("res://sounds/sfx/VoiceLines/The_Gauntlet.wav"),preload("res://sounds/sfx/VoiceLines/Freeplay.wav")]

func _ready():
	setvol(.5)
	setmusicvol(.5)
	setsfxvol(.5)
	setvoicevol(.5)

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
		if(player.type == "SFX"):
			player.volume_linear = max_volume*max_sfx_volume
		elif(player.type == "MUSIC"):
			player.volume_linear = max_volume*max_music_volume
		elif(player.type == "VOICE"):
			player.volume_linear = max_volume

func setsfxvol(newvol: float):
	
	var players = self.get_children()
	max_sfx_volume = newvol # only applies to sfx
	for player: AudioStreamPlayer in players:
		if(player.type == "SFX"):
			player.volume_linear = newvol*max_volume
			

func setmusicvol(newvol: float):
	var players = self.get_children()
	max_music_volume = newvol #only applies to music
	for player: AudioStreamPlayer in players:
		if(player.type == "MUSIC"):
			player.volume_linear = newvol*max_volume


func setvoicevol(newvol: float):
	var players = self.get_children()
	max_voice_volume = newvol #only applies to voices
	for player: AudioStreamPlayer in players:
		if(player.type == "VOICE"):
			print("heyy")
			player.volume_linear = newvol*max_volume

#func volmod(vol: float):
	#print(vol)
	#var mod: float = rng.randf()*.1
	#print(mod)
	#var newvol = vol-mod
	#if(newvol>=0.0):
		#newvol = 0
	#return newvol

func ball_hit(speed):
	#$BallHit.volume_db = 0
	if(speed > SPEED_MAX_VOLUME): # clamp max speed (don't need to clamp in other direction since speed > 0
		speed = SPEED_MAX_VOLUME
	print(speed)
	var volume = speed/SPEED_MAX_VOLUME*max_volume*max_sfx_volume
	print(volume)
	
	$BallHit.volume_linear = volume*max_volume
	print($BallHit.volume_db)
	$BallHit.play()
	
func ball_hit_menu():
	$StickHit.volume_linear = max_volume*max_sfx_volume
	$StickHit.play()

func ball_break():
	$BallBreak.play()

func level_complete(_type: int): # based on number, hopefully can be set in script and be a single level complete call.
								 # should be 0 = fail, 1-3 = that many stars
	print(_type)
	$LevelComplete.stream = instrumentcompletesounds[_type]
	$LevelComplete.volume_linear = max_volume*max_sfx_volume
	$LevelComplete.play()

func wall_hit(speed):
	if(speed > SPEED_MAX_VOLUME): # clamp max speed (don't need to clamp in other direction since speed > 0
		speed = SPEED_MAX_VOLUME
	print(speed)
	var volume = speed/SPEED_MAX_VOLUME*max_volume
	print(volume)
	
	$WallHit.volume_linear = volume
	$WallHit.play()

func stick_hit(power):
	if(power > POWER_MAX_VOLUME): # clamp max speed (don't need to clamp in other direction since speed > 0
		power = POWER_MAX_VOLUME
	print(power)
	var volume = power/POWER_MAX_VOLUME*max_volume
	print(volume)
	
	$StickHit.volume_linear = volume
	$StickHit.play()

func ball_sink(): #should randomize between the three available takes ideally. Important for this sound b/c it's crunchy
	var soundnum: int = rng.randi_range(0,2)
	$BallSink.stream = ballsinksounds[soundnum]
	$BallSink.volume_linear = max_sfx_volume*max_volume
	$BallSink.play()
	
func pocket_drone():
	$Pocket.volume_linear = max_sfx_volume*max_volume
	if(!$Pocket.playing):
		$Pocket.play()

func pocket_off():
	if($Pocket.playing):
		$Pocket.stop()

func explosion():
	$Explosion.volume_linear = max_sfx_volume*max_volume
	$Explosion.play()

func level_voice(level: int):
	$LevelVoice.stream = levelstartsounds[level]
	$LevelVoice.volume_linear = max_voice_volume*max_volume
	$LevelVoice.play()

func complete_voice(_type: int):
	var soundrand: int = rng.randi_range(0,2)
	if(_type == 3):
		var secretrand: int = rng.randi_range(0,100)
		if(secretrand == 0):
			$LevelCompleteVoice.stream = secretvoice[soundrand]
			$LevelCompleteVoice.play()
	print(voicecompletesounds[_type][soundrand])
	$LevelCompleteVoice.stream = voicecompletesounds[_type][soundrand]
	$LevelCompleteVoice.volume_linear=max_voice_volume*max_volume
	$LevelCompleteVoice.play()

func power_on():
	$PowerOn.volume_linear = max_sfx_volume*max_volume
	$PowerOn.play()
	
