extends Node2D

signal food
signal mood
signal tech
signal exit
signal tooltip

var tooltip_control = ''

func _ready():
	$Interactive/Food/Area2D.connect('mouse_entered', self, 'food_mouse_in')
	$Interactive/Food/Area2D.connect('mouse_exited', self, 'food_mouse_out')
	$Interactive/Food/Area2D.connect('input_event', self, 'food_click')
	
	$Interactive/Mood/Area2D.connect('mouse_entered', self, 'mood_mouse_in')
	$Interactive/Mood/Area2D.connect('mouse_exited', self, 'mood_mouse_out')
	$Interactive/Mood/Area2D.connect('input_event', self, 'mood_click')
	
	$Interactive/Tech/Area2D.connect('mouse_entered', self, 'tech_mouse_in')
	$Interactive/Tech/Area2D.connect('mouse_exited', self, 'tech_mouse_out')
	$Interactive/Tech/Area2D.connect('input_event', self, 'tech_click')

	$Interactive/Exit/Area2D.connect('mouse_entered', self, 'exit_mouse_in')
	$Interactive/Exit/Area2D.connect('mouse_exited', self, 'exit_mouse_out')
	$Interactive/Exit/Area2D.connect('input_event', self, 'exit_click')

func mood_mouse_in():
	$Interactive/Mood.modulate = Color(2.0, 2.0, 2.0)
	tooltip_control = 'mood'
	emit_signal('tooltip', 'Sightseeing')

func mood_mouse_out():
	$Interactive/Mood.modulate = Color(1.0, 1.0, 1.0)
	if tooltip_control == 'mood':
		emit_signal('tooltip', '')

func mood_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal('mood', self)
		
func food_mouse_in():
	$Interactive/Food.modulate = Color(2.0, 2.0, 2.0)
	tooltip_control = 'food'
	emit_signal('tooltip', 'Yum-yum')

func food_mouse_out():
	$Interactive/Food.modulate = Color(1.0, 1.0, 1.0)
	if tooltip_control == 'food':
		emit_signal('tooltip', '')

func food_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal('food', self)
		
func tech_mouse_in():
	$Interactive/Tech.modulate = Color(2.0, 2.0, 2.0)
	tooltip_control = 'tech'
	emit_signal('tooltip', 'Electronics Megamarket')

func tech_mouse_out():
	$Interactive/Tech.modulate = Color(1.0, 1.0, 1.0)
	if tooltip_control == 'tech':
		emit_signal('tooltip', '')

func tech_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal('tech', self)

func exit_mouse_in():
	$Interactive/Exit.modulate = Color(2.0, 2.0, 2.0)
	tooltip_control = 'exit'
	emit_signal('tooltip', 'Airport')

func exit_mouse_out():
	$Interactive/Exit.modulate = Color(1.0, 1.0, 1.0)
	if tooltip_control == 'exit':
		emit_signal('tooltip', '')

func exit_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal('exit', self)
