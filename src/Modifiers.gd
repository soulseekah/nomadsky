class_name Modifiers


# Where you are in the world
class Location:
	var cost: int
	var bonus: float
	var name: String
	var tech
	var slug: String

	class Pyongyang extends Location:
		func _init():
			cost = 12
			bonus = 1.0
			name = 'Pyongyang'
			tech = Workstation.Red
			slug = 'pyongyang'
			
	class Mongolia extends Location:
		func _init():
			cost = 25
			bonus = 1.5
			name = 'Mongolia'
			tech = Workstation.Renovo
			slug = 'mongolia'
			
	class Moscow extends Location:
		func _init():
			cost = 50
			bonus = 2.0
			name = 'Moscow'
			tech = Workstation.Komputer
			slug = 'moscow'
			
	class Spain extends Location:
		func _init():
			cost = 100
			bonus = 3.0
			name = 'Spain'
			tech = Workstation.LosComputos
			slug = 'spain'
			
	class NewYork extends Location:
		func _init():
			cost = 100
			bonus = 5.0
			name = 'New York'
			tech = Workstation.Wacbook
			slug = 'newyork'

# What you do your work on
class Workstation:
	var cost: int
	var bonus: float
	var name: String
	
	class Red extends Workstation:
		func _init():
			cost = 5
			bonus = 1.0
			name = 'Red'
			
	
	class Renovo extends Workstation:
		func _init():
			cost = 200
			bonus = 0.9
			name = 'Renovo'
			
	class Komputer extends Workstation:
		func _init():
			cost = 500
			bonus = 0.9
			name = 'Komputer'
		
	class LosComputos extends Workstation:
		func _init():
			cost = 1200
			bonus = 0.7
			name = 'Los Computos'

	class Wacbook extends Workstation:
		func _init():
			cost = 2500
			bonus = 0.5
			name = 'Wacbook Pro'

# Where you live
class Quarters:
	var cost: int
	var bonus: float

	class Camping extends Quarters:
		func _init():
			cost = 0
			bonus = 0
	
	class Hostel extends Quarters:
		func _init():
			cost = 100
			bonus = 10

	class Hotel extends Quarters:
		func _init():
			cost = 200
			bonus = 20

	class Apartment extends Quarters:
		func _init():
			cost = 150
			bonus = 30


# What your pet is
class Pet:
	var cost: int
	var bonus: float
	var type: String
	
	class Cat extends Pet:
		func _init():
			cost = 10
			bonus = 7
			type = 'cat'

	class Dog extends Pet:
		func _init():
			cost = 20
			bonus = 14
			type = 'dog'
