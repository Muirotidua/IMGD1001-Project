extends Node2D

var loaded: bool = false

func _ready():
	$FadeTimer.start()
	$Fade/AnimationPlayer.play("fade_out_black");
	$WPILogo.set_scale(Vector2(0.3,0.3))

func _process(delta: float):
	$WPILogo.set_scale($WPILogo.get_scale() + Vector2(0.01, 0.01) * delta)

func _on_fade_timer_timeout() -> void:
	if loaded:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	else:
		loaded = true
		$SplashTimer.start()
		

func _on_splash_timer_timeout() -> void:
	$FadeTimer.start()
	$Fade/AnimationPlayer.play("fade_in_black")
