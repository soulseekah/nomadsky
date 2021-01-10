extends Node

class_name Nomad

# C.R.E.A.M
var money: int


# Properties
var quarters: Modifiers.Quarters
var pet: Modifiers.Pet
var location: Modifiers.Location
var workstation: Modifiers.Workstation


# Skills
var copywriting: int
var design: int
var code: int
var gamedev: int
var soft: int


# Stats
var hunger: int
var health: int
var mood: int
var karma: int
var rating: int
var energy: int


# Courses
var courses: Array = []

func _to_string():
	return JSON.print({
		'money': money,
		'hunger': hunger,
		'health': health,
		'mood': mood,
		'karma': karma,
		'rating': rating,
		'energy': energy,
	})
