extends Level_template

@onready var tutorial2: AnimatedSprite2D = $Tutorial2

func _ready():
	tutorial2.show()
	tutorial2.play("3a")
	super._ready()
	
func hide_tutorials():
	super.hide_tutorials()
	tutorial2.hide()
	tutorial2.stop()
