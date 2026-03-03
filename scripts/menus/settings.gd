extends Control

@onready var AudioMenu = $AudioMenu
@onready var ControlsMenu = $ControlsMenu
@onready var MasterSlider = $AudioMenu/MasterSlider
@onready var MusicSlider = $AudioMenu/MusicSlider
@onready var SFXSlider  = $AudioMenu/SFXSlider
@onready var MuteMaster = $AudioMenu/MuteMaster
@onready var MuteMusic = $AudioMenu/MuteMusic
@onready var MuteSFX = $AudioMenu/MuteSFX
@onready var Location: String = ""


var MasterValue = 0.5
var MusicValue = 0.5
var SFXValue = 0.5



func _ready() -> void:
	MasterSlider.value = AudioLevels.MasterLevel
	MusicSlider.value = AudioLevels.MusicLevel
	SFXSlider.value = AudioLevels.SFXLevel
	

func _on_audio_tab_pressed() -> void:
	if (!AudioMenu.visible):
		ControlsMenu.visible = false
		AudioMenu.visible = true


func _on_controls_tab_pressed() -> void:
	if (!ControlsMenu.visible):
		AudioMenu.visible = false
		ControlsMenu.visible = true
		


func _on_master_slider_value_changed(value: float) -> void:
	AudioManager.setvol(value)
	print(value)
	if (value == 0.0):
		MuteMaster.button_pressed = true
	else:
		MuteMaster.button_pressed = false
func _on_music_slider_value_changed(value: float) -> void:
	AudioManager.setmusicvol(value)
	if (value == 0.0):
		MuteMusic.button_pressed = true
	else:
		MuteMusic.button_pressed = false
	
func _on_sfx_slider_value_changed(value: float) -> void:
	AudioManager.setsfxvol(value)
	if (value == 0.0):
		MuteSFX.button_pressed = true
	else:
		MuteSFX.button_pressed = false

func _on_mute_master_pressed() -> void:
	print (MasterValue)
	if (MuteMaster.button_pressed):
		AudioManager.setvol(0.0)
		MasterSlider.value = 0
	elif (!MuteMaster.button_pressed): 
		AudioManager.setvol(MasterValue)
		MasterSlider.value = MasterValue
		


func _on_mute_music_pressed() -> void:
	if (MuteMusic.button_pressed):
		AudioManager.setmusicvol(0.0)
		MusicSlider.value = 0
	else:
		AudioManager.setmusicvol(MusicValue)
		MusicSlider.value = MusicValue


func _on_mute_sfx_pressed() -> void:
	if (MuteSFX.button_pressed):
		AudioManager.setsfxvol(0.0)
		SFXSlider.value = 0
	else:
		AudioManager.setsfxvol(SFXValue)
		SFXSlider.value = SFXValue
		AudioManager.ball_sink()


func _on_master_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		MasterValue = MasterSlider.value


func _on_music_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		MusicValue = MusicSlider.value


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		SFXValue = SFXSlider.value
	AudioManager.ball_sink()
	


func _on_back_pressed() -> void:
	AudioLevels.set_audio(MasterSlider.value, MusicSlider.value, SFXSlider.value)
	if (Location == ""):
		get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
	if (Location == "Main Menu"):
		print (Location)
		get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
	if (Location == "Level Paused"):
		
		visible = false
