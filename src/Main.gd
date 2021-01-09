extends Node


var time: float
var nomad: Nomad

var last_pick: int


func _ready():
	nomad = Nomad.new()

func _process(delta):
	time += delta
	
	# Pick a card
	if int(time) - last_pick > 4:
		print(Cards.pick(''))
		last_pick = int(time)
