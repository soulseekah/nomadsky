extends Node


var time: float
var nomad: Nomad

var location: Modifiers.Location

var last_pick: int


func _ready():
	nomad = Nomad.new()
	location = Modifiers.Location.Pyongyang.new()
	
	$Location/Button.show()
	$Workstation.hide()
	
	$Location/Button.connect('pressed', self, 'to_workstation')
	$Workstation/Button.connect('pressed', self, 'to_location')

	$Timer.text = str(time);

func _process(delta):
	time += delta
	
	# Pick a card
	if int(time) - last_pick > 4:
		print(Cards.pick())
		last_pick = int(time)

	$Timer.text = str(int(time));

func to_workstation():
	$Workstation.show()

func to_location():
	$Workstation.hide()
