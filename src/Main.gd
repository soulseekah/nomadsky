extends Node

signal card_closed
signal quiz_closed
signal confirm_closed(action)

class_name Main

var time: int
var nomad: Nomad

var location: Modifiers.Location

var last_pick: int
var current_card
var queued_card
var actions
var valid_courses: Array

func _ready():
	randomize()

	nomad = Nomad.new()
	nomad.money = 200
	nomad.health = 90
	nomad.karma = 50
	nomad.energy = 90
	nomad.hunger = 90
	nomad.mood = 80
	nomad.rating = 0

	location = Modifiers.Location.Pyongyang.new()
	actions = [$Card/Action1, $Card/Action2, $Card/Action3]
	
	$Status/Actions.hide()
	$Workstation.hide()
	
	$Status/Actions/Work.connect('pressed', self, 'workstation_open')
	$Status/Actions/Sleep.connect('pressed', self, 'sleep')
	
	$Workstation/Actions/Shutdown.connect('pressed', self, 'workstation_close')
	$Workstation/Actions/Work.connect('pressed', self, 'find_work')

	$Workstation/Actions/Courses.connect('pressed', self, 'show_courses')
	$Workstation/Courses/Cancel.connect('pressed', self, 'hide_courses')
	$Workstation/Courses/Submit.connect('pressed', self, 'do_course')
	$Workstation/Courses/Quiz/Submit.connect('pressed', self, 'do_quiz')
	
	$Error/Okay.connect('pressed', self, 'dismiss_error')
	$Success/Okay.connect('pressed', self, 'dismiss_success')
	$Confirm/Cancel.connect('pressed', self, 'confirm_cancel')
	$Confirm/Okay.connect('pressed', self, 'confirm_okay')
	
	$Card/Action1.connect('pressed', self, 'do_action_1')
	$Card/Action2.connect('pressed', self, 'do_action_2')
	$Card/Action3.connect('pressed', self, 'do_action_3')
	
	nomad.connect('dead', self, 'dead')
	
	# Connect location events
	$Locations/Pyongyang.connect('food', self, 'click_food')
	$Locations/Pyongyang.connect('mood', self, 'click_mood')
	$Locations/Pyongyang.connect('exit', self, 'click_exit')

	$Locations/Mongolia.connect('food', self, 'click_food')
	$Locations/Mongolia.connect('mood', self, 'click_mood')
	$Locations/Mongolia.connect('mood', self, 'click_tech')
	$Locations/Mongolia.connect('exit', self, 'click_exit')

	# The first location
	$Locations/Pyongyang.show()

	#yield(get_tree().create_timer(3.0), 'timeout')

	# First card
	current_card = Cards.pick(['info'], self)
	self.show_card(current_card)
	
	yield(self, 'card_closed')
	$Status/Actions.show()
	
	var timer = Timer.new()
	timer.set_wait_time(5.0)
	timer.set_one_shot(false)
	timer.connect('timeout', self, 'maybe_pick_card')
	self.add_child(timer)
	timer.start()
	
func tick(amount):
	if time % 24 + amount > 23:
		if nomad.pet:
			print('Pet: %s $%d +%d mood' % [nomad.pet.type, nomad.pet.cost, nomad.pet.bonus])
			nomad.money(-nomad.pet.cost)
			nomad.mood(nomad.pet.bonus)

	time += amount

func _process(delta):
	var day_label = 1
	var time_label = 0
	day_label += time / 24
	time_label = time % 24

	$Status/Timer.text = 'Day %d   %d:00' % [day_label, time_label]
	$Status/Stats.text = str(nomad)
	$Status/Money.text = str(nomad.money)
	
	if nomad.mood >= 60:
		$Status/Mood/Happy.show()
		$Status/Mood/Indifferent.hide()
		$Status/Mood/Sad.hide()
	elif nomad.mood >= 30:
		$Status/Mood/Happy.hide()
		$Status/Mood/Indifferent.show()
		$Status/Mood/Sad.hide()
	else:
		$Status/Mood/Happy.hide()
		$Status/Mood/Indifferent.hide()
		$Status/Mood/Sad.show()
		
	$Status/Energy.value = nomad.energy
	if nomad.energy <= 30:
		$Status/Energy.get('custom_styles/fg').bg_color = Color(0.7, 0, 0)
	else:
		$Status/Energy.get('custom_styles/fg').bg_color = Color(0, 0.7, 0)
	
	if queued_card and self.is_idle():
		current_card = queued_card
		
		if $Workstation.visible:
			$Workstation/Actions.hide()
		else:
			$Status/Actions.hide()
		
		self.show_card(current_card)
		yield(self, 'card_closed')
		queued_card = null
		
		if $Workstation.visible:
			$Workstation/Actions.show()
		else:
			$Status/Actions.show()

func is_idle():
	if $Blackout.visible:
		return false
		
	if $Error.visible:
		return false
		
	if $Card.visible:
		return false
		
	if $Workstation/Loading.visible:
		return false
		
	if current_card:
		return false
		
	if $Workstation/Courses.visible:
		return false
		
	return true
	
		
func dismiss_error():
	$Error.hide()
	
func dismiss_success():
	$Success.hide()

func confirm(message: String):
	$Confirm/Label.text = message
	$Confirm.show()

func confirm_cancel():
	$Confirm.hide()
	emit_signal('confirm_closed', 'cancel')
	
func confirm_okay():
	$Confirm.hide()
	emit_signal('confirm_closed', 'okay')
	
func maybe_pick_card():
	if randf() > 0.9 and not queued_card:
		queued_card = Cards.pick(['info', 'accident', 'gift', 'decision'], self)

func dead(why):
	print('died')
	var reasons = {
		'hunger': 'You so hungry, you so dead.',
		'health': 'You so unhealthy, you so dead.'
	}

	$Death.show()
	$Death/Fade.play('Fade')
	$Death/Label.hide()
	yield($Death/Fade, 'animation_finished')
	
	$Death/Label.text = reasons[why]
	$Death/Label.show()

func sleep():
	$Blackout.show()
	$Blackout/Fade.play('Fade')
	yield($Blackout/Fade, 'animation_finished')
	
	$Blackout/Label.text = 'Sleeping...'
	$Blackout/Label.show()
	yield(get_tree().create_timer(3.0), 'timeout')
	$Blackout/Label.hide()
	
	self.tick(8)
	nomad.energy(+70)
	nomad.health(+5)
	nomad.hunger(-10)
	
	$Blackout/Fade.play_backwards('Fade')
	yield($Blackout/Fade, 'animation_finished')
	$Blackout.hide()

func error(message: String):
	$Error/Label.text = message
	$Error.show()
	
func success(message: String):
	$Success/Label.text = message
	$Success.show()

func click_food(node: Node):
	print('Food clicked in %s' % node.name)
	var cost = 0
	var message = ''

	match node.name:
		'Pyongyang':
			cost = 10
			message = 'You got some bread...'
		'Mongolia':
			cost = 50
			message = 'This horse milk is good.'

	if nomad.money < cost:
		self.error('You can\'t afford to eat.')
		return

	$Blackout.show()
	$Blackout/Fade.play('Fade')
	yield($Blackout/Fade, 'animation_finished')
	
	$Blackout/Label.text = message
	$Blackout/Label.show()
	yield(get_tree().create_timer(3.0), 'timeout')
	$Blackout/Label.hide()

	self.tick(1)
	nomad.energy(+5)
	nomad.health(+5)
	nomad.hunger(+80)
	nomad.money(-cost)

	$Blackout/Fade.play_backwards('Fade')
	yield($Blackout/Fade, 'animation_finished')
	$Blackout.hide()

func find_work():
	var energy_cost = 1
	if nomad.energy < energy_cost:
		self.error('Not enough energy to work right now. Maybe I should take a nap...')
		return
		
	if nomad.mood < 5:
		self.error('Not in the mood for working right now.')
		return
		
	if nomad.hunger < 10:
		self.error('Too hungry to work. Maybe I should eat something.')
		return

	call_deferred('play', 'click1')
	
	$Workstation/Loading.show()
	$Workstation/Actions.hide()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	yield(get_tree().create_timer(rng.randf_range(2.0, 4.0)), 'timeout')
	$Workstation/Loading.hide()
	
	self.tick(1)
	nomad.energy(-1)
	nomad.hunger(-1)

	# Pick a card
	current_card = Cards.pick(['work'], self)
	self.show_card(current_card)
	
	yield(self, 'card_closed')
	$Workstation/Actions.show()

func show_card(card):
	if card.sound:
		play(card.sound)
	else:
		if card.type == 'work':
			play('work')
	
	$Card/Text.bbcode_text = '%s\n\n%s' % [card.title, card.description]

	# Hide all actions
	for action in actions:
		action.hide()

	var i = 0
	for action in card.actions:
		actions[i].text = action.capitalize()
		actions[i].show()
		i += 1

	if card.type == 'work':
		var accept = card.actions['accept']
		$Card/Text.bbcode_text += '\n\n$%d, ~%d hrs' % [accept['money'], accept['time']]

	$Card.show()

func workstation_open():
	if current_card:
		return
		
	call_deferred('play', 'click1')

	$Workstation.show()
	$Status/Actions.hide()

func workstation_close():
	call_deferred('play', 'click2')
	
	if current_card:
		return

	$Workstation.hide()
	$Status/Actions.show()
	
func show_courses():
	call_deferred('play', 'click1')
	
	valid_courses = Courses.available(self)
	
	if valid_courses.size() < 1:
		self.error('No courses available at this time')
		return
	
	var placeholders = [$Workstation/Courses/Course1, $Workstation/Courses/Course2, $Workstation/Courses/Course3]

	for label in placeholders:
		label.hide()
		label.pressed = false
		
	var i = 0
	for course in valid_courses:
		placeholders[i].text = '%s, $%d' % [course.name, course.cost]
		placeholders[i].show()
		i += 1

	placeholders.front().pressed = true

	$Workstation/Courses.show()

func hide_courses():
	call_deferred('play', 'click2')
	
	$Workstation/Courses.hide()

func do_course():
	call_deferred('play', 'click1')

	if nomad.mood < 5:
		self.error('Not in the mood for learning.')
		return
		
	if nomad.energy < 10:
		self.error('Not enough energy. Perhaps I could use some sleep.')
		return

	var placeholders = [$Workstation/Courses/Course1, $Workstation/Courses/Course2, $Workstation/Courses/Course3]
	var i = 0
	for radio in placeholders:
		if radio.is_pressed():
			break
		i += 1
	
	var course = valid_courses[i]
	
	if nomad.money < course.cost:
		self.error('Not enough money for this course.')
		return

	# Pay for the course
	nomad.money(-course.cost)

	$Workstation/Courses/Doing.show()
	yield(get_tree().create_timer(3.0), 'timeout')
	
	course.quizzes.shuffle()
	var quiz = course.quizzes.front()
	var answers = [$Workstation/Courses/Quiz/Answer1, $Workstation/Courses/Quiz/Answer2, $Workstation/Courses/Quiz/Answer3]

	$Workstation/Courses/Quiz/Question.text = quiz.question
	
	for answer in answers:
		answer.pressed = false
	
	answers.shuffle()
	$Workstation/Courses/Quiz/Answer1.pressed = true
	
	answers[0].text = quiz.answer
	answers[1].text = quiz.filler[0]
	answers[2].text = quiz.filler[1]
	
	$Workstation/Courses/Quiz.show()
	$Workstation/Courses/Doing.hide()
	yield(self, 'quiz_closed')

	# Correct answer
	if answers[0].is_pressed():
		course.done = true
		nomad.mood(+10)
	else:
		nomad.mood(-10)

	$Workstation/Courses/Quiz.hide()
	$Workstation/Courses.hide()

	if course.done:
		self.success('You passed the course. Congrats!')
		return

	self.error('You failed the course. Better luck next time!')
	return

func do_quiz():
	emit_signal('quiz_closed')

func do_action(index):
	var action_name = actions[index].text.to_lower()
	var action = current_card.actions[action_name]
	var energy_cost = 1
	
	if action.has('time'):
		energy_cost = action['time'] * 2

	var success: bool = true # TODO: calcs
	
	if current_card.type == 'work' and nomad.energy < energy_cost:
		success = false
		nomad.energy(+10 + energy_cost)
		nomad.health(-10)
		self.error('You fell asleep during assignment.')
	
	match action_name:
		'ignore': play('ignore')
		'accept': play('click2')
		'okay': play('ignore')
		'decline': play('reject')

	if (action.has('time')):
		self.tick(action['time'])
		nomad.energy(-energy_cost)
		nomad.hunger(-action['time'])

	if success:
		if (action.has('karma')):
			nomad.karma(action['karma'])
			
		if (action.has('money')):
			nomad.money(action['money'])

		if (action.has('mood')):
			nomad.mood(action['mood'])
			
		if (action.has('pet')):
			var pets = {
				'cat': Modifiers.Pet.Cat,
				'dog': Modifiers.Pet.Dog,
			}
			
			nomad.pet = pets[action['pet']].new()
			
		nomad.rating(+1)
	else:
		nomad.rating(-1)
		nomad.mood(-1)

	print('Action: %s' % action)
	print('Nomad: %s' % nomad)
	
	if not (action.has('skip') && action['skip']):
		current_card.done = true

	current_card = null
	$Card.hide()
	emit_signal('card_closed')
	
func click_exit(node: Node):
	print('Exit clicked in %s' % node.name)
	var cost = 0
	var action = ''
	var message = ''
	var next

	if node.name == 'Pyongyang':
		cost = 1000

		if nomad.money < cost:
			self.error('Doesn\'t look like I have enough money to leave this place. The guards want $1k to look away while I climb the fence.')
			return
			
		self.confirm('I think I\'m ready to leave this place. Pay the guards to look away while I climb the fence?')
		action = yield(self, 'confirm_closed')
		if action == 'cancel':
			return

		message = 'Heading to Mongolia'
		next = $Locations/Mongolia

	$Blackout/Label.hide()
	$Blackout.show()
	$Blackout/Fade.play('Fade')
	yield($Blackout/Fade, 'animation_finished')

	$Blackout/Label.text = message
	$Blackout/Label.show()
	yield(get_tree().create_timer(3.0), 'timeout')
	$Blackout/Label.hide()

	self.tick(8)
	nomad.money(-cost)
	nomad.mood(+10)
	
	node.hide()
	next.show()
	
	$BackgroundAudio.stream = load("res://assets/sound/bgm/%s.ogg" % next.name.to_lower())
	$BackgroundAudio.play()

	$Blackout/Fade.play_backwards('Fade')
	yield($Blackout/Fade, 'animation_finished')
	$Blackout.hide()

func play(sound: String):
	$SFX.stream = load("res://assets/sound/sfx/%s.ogg" % sound)
	$SFX.stream.loop = false
	$SFX.play()

func do_action_1():
	return self.do_action(0)
	
func do_action_2():
	return self.do_action(1)

func do_action_3():
	return self.do_action(2)

func click_mood(node: Node):
	print('Mood clicked in %s' % node.name)
	
func click_tech(node: Node):
	print('Tech clicked in %s' % node.name)
	
