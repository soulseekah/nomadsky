extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Actions.hide()
	$Actions/Button.connect('pressed', self, 'play_pressed')
	$Actions/CreditsButton.connect('pressed', self, 'credits_open')
	$Credits/Okay.connect('pressed', self, 'credits_close')
	
	$Overlay.show()
	$Overlay/Fade.play('Fade')
	yield($Overlay/Fade, 'animation_finished')
	$Overlay.hide()
	$Actions.show()

func play_pressed():
	$Overlay.show()
	$Overlay/Fade.play_backwards('Fade')
	yield($Overlay/Fade, 'animation_finished')
	
	get_tree().change_scene("res://scenes/Main.tscn")

func credits_open():
	$Credits.show()

func credits_close():
	$Credits.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
