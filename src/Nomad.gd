extends Node

class_name Nomad

var main

signal dead(why)

# C.R.E.A.M
var money: int

# Properties
var quarters: Modifiers.Quarters
var pet
var location
var workstation


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

var stats = {
	'revenue': 0,
	'expenses': 0,
	'cards': 0,
	'courses': 0,
}

# Courses
var courses: Array = []

# Change stats

func hunger(amount: int):
	hunger = self.limit(hunger + amount)
	if hunger < 30:
		main.play('hunger')
	if hunger == 0:
		emit_signal('dead', 'hunger')

func health(amount: int):
	health = self.limit(health + amount)
	if health == 0:
		emit_signal('dead', 'health')

func mood(amount: int):
	mood = self.limit(mood + amount)

func karma(amount: int):
	karma = self.limit(karma + amount)

func rating(amount: int):
	rating = self.limit(rating + amount)

func energy(amount: int):
	energy = self.limit(energy + amount)
	
func money(amount: int):
	if amount > 0:
		self.stats['revenue'] += amount
	else:
		self.stats['expenses'] += amount * -1

	money += amount
	if money < 0:
		money = 0

func _to_string():
	return JSON.print({
		'money': money,
		'hunger': hunger,
		'health': health,
		'mood': mood,
		'karma': karma,
		'rating': rating,
		'energy': energy,
		'location': location.name,
		'workstation': workstation.name,

		'copywriting': copywriting,
		'design': design,
		'code': code,
		'gamedev': gamedev,
		'soft': soft,
	})

# Limit a value between 0 and 100
func limit(value: int):
	return clamp(value, 0, 100)
