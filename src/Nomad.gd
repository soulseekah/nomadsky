extends Node

class_name Nomad

signal dead(why)

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

# Change stats

func hunger(amount: int):
	hunger = self.limit(hunger + amount)
	if hunger == 0:
		emit_signal('dead', 'hunger')

func health(amount: int):
	health = self.limit(health + amount)

func mood(amount: int):
	mood = self.limit(mood + amount)

func karma(amount: int):
	karma = self.limit(karma + amount)

func rating(amount: int):
	rating = self.limit(rating + amount)

func energy(amount: int):
	energy = self.limit(energy + amount)
	
func money(amount: int):
	money += amount

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

# Limit a value between 0 and 100
func limit(value: int):
	if value < 0:
		return 0
		
	if value > 100:
		return 100
		
	return value

