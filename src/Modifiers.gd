class_name Modifiers


# Where you are in the world
class Location:
	var cost: int
	var bonus: float
	var name: String
	
	class Pyongyang extends Location:
		func _init():
			cost = 12
			bonus = 1.0
			name = 'Pyongyang'
			
	class Mongolia extends Location:
		func _init():
			cost = 25
			bonus = 1.5
			name = 'Mongolia'
			
	class Moscow extends Location:
		func _init():
			cost = 50
			bonus = 2.0
			name = 'Moscow'
			
	class Spain extends Location:
		func _init():
			cost = 100
			bonus = 3.0
			name = 'Spain'
			
	class NewYork extends Location:
		func _init():
			cost = 100
			bonus = 4.0
			name = 'New York'

# What you do your work on
class Workstation:
	var cost: int
	var bonus: float
	var health: int
	
	class Red extends Workstation:
		func _init():
			cost = 5
			bonus = 0
	
	class Renovo extends Workstation:
		func _init():
			cost = 10
			bonus = 0

	class Wacbook extends Workstation:
		func _init():
			cost = 1000
			bonus = 30


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
