class_name Modifiers


# Where you are in the world
class Location:
	var cost: int
	var bonus: float
	
	class Beijing extends Location:
		func _init():
			cost = 100
			bonus = 10 


# What you do your work on
class Workstation:
	var cost: int
	var bonus: float

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
	
	class Cat extends Pet:
		func _init():
			cost = 10
			bonus = 7

	class Dog extends Pet:
		func _init():
			cost = 20
			bonus = 14
