extends Node2D

signal food
signal mood
signal tech
signal exit
signal tooltip

func _ready():
	$Interactive/Food/Area2D.connect('mouse_entered', self, 'food_mouse_in')
	$Interactive/Food/Area2D.connect('mouse_exited', self, 'food_mouse_out')
	$Interactive/Food/Area2D.connect('input_event', self, 'food_click')
	
	$Interactive/Mood/Area2D.connect('mouse_entered', self, 'mood_mouse_in')
	$Interactive/Mood/Area2D.connect('mouse_exited', self, 'mood_mouse_out')
	$Interactive/Mood/Area2D.connect('input_event', self, 'mood_click')
		
	$Interactive/Exit/Area2D.connect('mouse_entered', self, 'exit_mouse_in')
	$Interactive/Exit/Area2D.connect('mouse_exited', self, 'exit_mouse_out')
	$Interactive/Exit/Area2D.connect('input_event', self, 'exit_click')

func mood_mouse_in():
	$Interactive/Mood.modulate = Color(2.0, 2.0, 2.0)
	emit_signal('tooltip', 'Praise The Leader')

func mood_mouse_out():
	$Interactive/Mood.modulate = Color(1.0, 1.0, 1.0)
	emit_signal('tooltip', '')

func mood_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal('mood', self)
		
func food_mouse_in():
	$Interactive/Food.modulate = Color(2.0, 2.0, 2.0)
	emit_signal('tooltip', 'Bread and water')

func food_mouse_out():
	$Interactive/Food.modulate = Color(1.0, 1.0, 1.0)
	emit_signal('tooltip', '')

func food_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal('food', self)
				
func exit_mouse_in():
	$Interactive/Exit.modulate = Color(2.0, 2.0, 2.0)
	emit_signal('tooltip', 'Jump the fence')

func exit_mouse_out():
	$Interactive/Exit.modulate = Color(1.0, 1.0, 1.0)
	emit_signal('tooltip', '')

func exit_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal('exit', self)
