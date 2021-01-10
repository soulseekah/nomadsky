extends Node

var time: float
var nomad: Nomad

var location: Modifiers.Location

var last_pick: int
var current_card
var actions


func _ready():
	nomad = Nomad.new()
	nomad.money = 15
	nomad.health = 90
	nomad.karma = 50
	nomad.energy = 90
	nomad.hunger = 80
	nomad.rating = 0

	location = Modifiers.Location.Pyongyang.new()
	actions = [$Card/Action1, $Card/Action2, $Card/Action3]
	
	$Actions.show()
	$Workstation.hide()
	
	$Actions/Work.connect('pressed', self, 'workstation_open')
	$Actions/Sleep.connect('pressed', self, 'sleep')
	$Actions/Eat.connect('pressed', self, 'eat')
	
	$Workstation/Actions/Shutdown.connect('pressed', self, 'workstation_close')
	$Workstation/Actions/Work.connect('pressed', self, 'find_work')
	
	$Error/Okay.connect('pressed', self, 'dismiss_error')
	
	$Card/Action1.connect('pressed', self, 'do_action_1')
	$Card/Action2.connect('pressed', self, 'do_action_2')
	$Card/Action3.connect('pressed', self, 'do_action_3')
	
	nomad.connect('dead', self, 'dead')

	$Timer.text = str(time);

func _process(delta):
	$Timer.text = 'Time: %s' % str(int(time))
	$Stats.text = str(nomad)

func dismiss_error():
	$Error.hide()

func dead(why):
	var reasons = {
		'hunger': 'You so hungry, you dead.'
	}

	$Blackout.show()
	$Blackout/Fade.play('Fade')
	yield($Blackout/Fade, 'animation_finished')
	
	$Blackout/Label.text = reasons[why]
	$Blackout/Label.show()

func sleep():
	$Blackout.show()
	$Blackout/Fade.play('Fade')
	yield($Blackout/Fade, 'animation_finished')
	
	$Blackout/Label.text = 'Sleeping...'
	$Blackout/Label.show()
	yield(get_tree().create_timer(3.0), 'timeout')
	$Blackout/Label.hide()
	
	time += 8
	nomad.energy(+70)
	nomad.health(+5)
	nomad.hunger(-10)
	
	$Blackout/Fade.play_backwards('Fade')
	yield($Blackout/Fade, 'animation_finished')
	$Blackout.hide()

func eat():
	var cost = 10
	
	if nomad.money < cost:
		$Error/Label.text = 'You can\'t afford to eat.'
		$Error.show()
		return
		
	$Blackout.show()
	$Blackout/Fade.play('Fade')
	yield($Blackout/Fade, 'animation_finished')
	
	$Blackout/Label.text = 'Nom nom nom nom...'
	$Blackout/Label.show()
	yield(get_tree().create_timer(3.0), 'timeout')
	$Blackout/Label.hide()

	time += 1
	nomad.energy(+5)
	nomad.health(+5)
	nomad.hunger(+80)
	nomad.money(-cost)

	$Blackout/Fade.play_backwards('Fade')
	yield($Blackout/Fade, 'animation_finished')
	$Blackout.hide()

func find_work():
	$Workstation/Loading.show()
	$Workstation/Actions.hide()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	yield(get_tree().create_timer(rng.randf_range(2.0, 4.0)), 'timeout')
	$Workstation/Loading.hide()
	
	time += 1
	nomad.energy(-1)
	nomad.hunger(-1)

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
		$Card/Text.bbcode_text += '\n\n$%d, ~%d hrs' % [accept['money'], accept['time']]

	$Card.show()

func workstation_open():
	if current_card:
		return

	$Workstation.show()
	$Actions.hide()

func workstation_close():
	if current_card:
		return

	$Workstation.hide()
	$Actions.show()

func do_action(index):
	var action = current_card.actions[actions[index].text.to_lower()]

	if (action.has('time')):
		time += action['time']
		nomad.energy(-action['time'] * 2)
		nomad.hunger(-action['time'])
		
	if (action.has('karma')):
		nomad.karma(action['karma'])
		
	if (action.has('money')):
		nomad.money(action['money'])
	
	if (action.has('mood')):
		nomad.mood(action['mood'])

	print('Action: %s' % action)
	print('Nomad: %s' % nomad)
	
	if not (action.has('skip') && action['skip']):
		current_card.done = true

	current_card = null
	$Card.hide()
	$Workstation/Actions.show()

func do_action_1():
	return self.do_action(0)
	
func do_action_2():
	return self.do_action(1)

func do_action_3():
	return self.do_action(2)
