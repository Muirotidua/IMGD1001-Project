extends Node

var MasterLevel: float = 0.5
var MusicLevel: float = 0.5
var SFXLevel: float = 0.5
var VoiceLevel: float = 0.5

func set_audio(Master: float, Music: float , SFX: float, Voice: float):
	MasterLevel = Master
	MusicLevel = Music
	SFXLevel = SFX
	VoiceLevel = Voice
	
