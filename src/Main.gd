extends Node

var time: float
var nomad: Nomad

var location: Modifiers.Location

var last_pick: int
var current_card
var actions


func _ready():
	nomad = Nomad.new()
	nomad.health = 90
	nomad.karma = 50
	nomad.money = 100

	location = Modifiers.Location.Pyongyang.new()
	actions = [$Card/Action1, $Card/Action2, $Card/Action3]
	
	$Location/Button.show()
	$Workstation.hide()
	
	$Location/Button.connect('pressed', self, 'to_workstation')
	$Workstation/Button.connect('pressed', self, 'to_location')
	
	$Card/Action1.connect('pressed', self, 'do_action_1')
	$Card/Action2.connect('pressed', self, 'do_action_2')
	$Card/Action3.connect('pressed', self, 'do_action_3')

	$Timer.text = str(time);

func _process(delta):
	if current_card or not $Workstation.visible:
		return

	time += delta
	
	# Pick a card
	current_card = Cards.pick()

	$Card/Text.bbcode_text = '[b]%s[/b]\n\n%s' % [current_card.title, current_card.description]

	# Hide all actions
	for action in actions:
		action.hide()

	var i = 0
	for action in current_card.actions:
		actions[i].text = action.capitalize()
		actions[i].show()
		i += 1

	if current_card.type == 'work':
		var accept = current_card.actions['accept']
		$Card/Text.bbcode_text += '\n\n$%d, ~ %d hrs' % [accept['money'], accept['time']]

	$Card.show()
	last_pick = int(time)

	$Timer.text = str(int(time))

func to_workstation():
	$Workstation.show()

func to_location():
	$Workstation.hide()

func do_action(index):
	var action = current_card.actions[actions[index].text.to_lower()]

	if (action.has('time')):
		time += action['time']
		
	if (action.has('karma')):
		nomad.karma += action['karma']
		
	if (action.has('money')):
		nomad.money += action['money']
	
	if (action.has('mood')):
		nomad.mood += action['mood']

	print('Action: %s' % action)
	print('Nomad: %s' % nomad)
	
	if not (action.has('skip') && action['skip']):
		current_card.done = true

	current_card = null
	$Card.hide()

func do_action_1():
	return self.do_action(0)
	
func do_action_2():
	return self.do_action(1)

func do_action_3():
	return self.do_action(2)
