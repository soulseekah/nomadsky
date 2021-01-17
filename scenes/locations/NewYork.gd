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
	
	$Interactive/Tech/Area2D.connect('mouse_entered', self, 'tech_mouse_in')
	$Interactive/Tech/Area2D.connect('mouse_exited', self, 'tech_mouse_out')
	$Interactive/Tech/Area2D.connect('input_event', self, 'tech_click')

func mood_mouse_in():
	$Interactive/Mood.modulate = Color(2.0, 2.0, 2.0)
	emit_signal('tooltip', 'Strip Club')

func mood_mouse_out():
	$Interactive/Mood.modulate = Color(1.0, 1.0, 1.0)
	emit_signal('tooltip', '')

func mood_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal('mood', self)
		
func food_mouse_in():
	$Interactive/Food.modulate = Color(2.0, 2.0, 2.0)
	emit_signal('tooltip', 'Pizza')

func food_mouse_out():
	$Interactive/Food.modulate = Color(1.0, 1.0, 1.0)
	emit_signal('tooltip', '')

func food_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal('food', self)
		
func tech_mouse_in():
	$Interactive/Tech.modulate = Color(2.0, 2.0, 2.0)
	emit_signal('tooltip', 'Pawn shop')

func tech_mouse_out():
	$Interactive/Tech.modulate = Color(1.0, 1.0, 1.0)
	emit_signal('tooltip', '')

func tech_click(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal('tech', self)
