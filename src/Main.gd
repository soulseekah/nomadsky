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
	nomad.main = self
	nomad.money = 200
	nomad.health = 90
	nomad.karma = 100
	nomad.energy = 90
	nomad.hunger = 90
	nomad.mood = 90
	nomad.rating = 0

	nomad.location = Modifiers.Location.Pyongyang.new()
	nomad.workstation = Modifiers.Workstation.Red.new()
	actions = [$Card/Action1, $Card/Action2, $Card/Action3]

	$Status/Actions.hide()
	$Workstation.hide()

	$Status/Actions/Work.connect('pressed', self, 'workstation_open')
	$Status/Actions/Sleep.connect('pressed', self, 'sleep')
	$Status/Actions/Pet/Cat.connect('pressed', self, 'meow')
	$Status/Actions/Pet/Dog.connect('pressed', self, 'woof')

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
	$Locations/Mongolia.connect('tech', self, 'click_tech')
	$Locations/Mongolia.connect('exit', self, 'click_exit')

	$Locations/Moscow.connect('food', self, 'click_food')
	$Locations/Moscow.connect('mood', self, 'click_mood')
	$Locations/Moscow.connect('tech', self, 'click_tech')
	$Locations/Moscow.connect('exit', self, 'click_exit')

	$Locations/Spain.connect('food', self, 'click_food')
	$Locations/Spain.connect('mood', self, 'click_mood')
	$Locations/Spain.connect('tech', self, 'click_tech')
	$Locations/Spain.connect('exit', self, 'click_exit')

	$Locations/NewYork.connect('food', self, 'click_food')
	$Locations/NewYork.connect('mood', self, 'click_mood')
	$Locations/NewYork.connect('tech', self, 'click_tech')

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
			print('Pet modifier: %s $%d +%d mood' % [nomad.pet.type, nomad.pet.cost, nomad.pet.bonus])
			nomad.money(-nomad.pet.cost)
			nomad.mood(nomad.pet.bonus)

		print('Location modifier: $%d' % nomad.location.cost)
		nomad.money(-nomad.location.cost)

	time += amount

	print('Nomad: %s' % nomad)

func _process(_delta):
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

	$Status/Hunger.value = nomad.hunger
	if nomad.hunger <= 30:
		$Status/Hunger.get('custom_styles/fg').bg_color = Color(0.7, 0, 0)
	else:
		$Status/Hunger.get('custom_styles/fg').bg_color = Color(0, 0.7, 0)

	$Status/Health.value = nomad.health
	if nomad.health <= 30:
		$Status/Health.get('custom_styles/fg').bg_color = Color(0.7, 0, 0)
	else:
		$Status/Health.get('custom_styles/fg').bg_color = Color(0, 0.7, 0)



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
		'health': 'You so unhealthy, you so dead.',
		'money': 'You no longer a nomad. You a bum.',
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
	if current_card or $Workstation.visible:
		return

	print('Food clicked in %s' % node.name)
	var cost = 0
	var message = ''

	match node.name:
		'Pyongyang':
			cost = 10
			message = 'You got some bread...'
		'Mongolia':
			cost = 20
			message = 'This horse milk is good.'
		'Moscow':
			cost = 50
			message = 'Some pelmeni with some soviet dumplings. Horosho.'
		'Spain':
			cost = 80
			message = 'Patatas bravas. Mmmmmm....'
		'NewYork':
			cost = 100
			message = 'An overpriced pizza. How nice.'

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
	if not current_card:
		self.error('Doesn\'t look like there\'s work at this time. Perhaps I should level up my skills.')
		$Workstation/Actions.show()
		return

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
		var reward = accept['money'] * nomad.location.bonus
		var time_estimate = max(accept['time'] * nomad.workstation.bonus, 1)
		$Card/Text.bbcode_text += '\n\n$%d, ~%d hrs' % [reward, time_estimate]

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
		placeholders[i].text = '%s: %s, $%d' % [course.type.capitalize(), course.name, course.cost]
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
		nomad[course.type] += 1
		nomad.mood(+10)
	else:
		nomad.mood(-10)

	$Workstation/Courses/Quiz.hide()
	$Workstation/Courses.hide()

	self.tick(2)

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
	var time_cost = 1
	var blackout = false

	if action.has('time'):
		energy_cost = action['time'] * 2
		time_cost = action['time']

	var success: bool = true
	var rate = 100

	rate = rate - (100 - nomad.mood) * 0.20
	rate = rate - (100 - nomad.karma) * 0.10

	if current_card.type == 'work' and nomad.energy < energy_cost and action_name == 'accept':
		success = false
		nomad.energy(+10 + energy_cost)
		nomad.health(-10)
		self.error('You fell asleep during the assignment.')

	if current_card.type == 'work' and success and action_name == 'accept' and randf() > float(rate) / 100:
		success = false
		var messages = [
			'You failed the task. Better luck next time.',
			'You failed the assignment. Maybe it\'s karma...',
			'You couldn\'t finish the work in time. Probably in a bad mood.',
			'You got distracted during work, you screwed up.',
			'You procrastinated for too long. Tough luck.',
		]

		self.error(messages[randi() % messages.size()])

	if current_card.type == 'work':
		time_cost = max(time_cost * nomad.workstation.bonus, 1)

	if current_card.type == 'accident' and action.has('time'):
		blackout = true

	match action_name:
		'ignore': play('ignore')
		'accept': play('click2')
		'okay': play('ignore')
		'decline': play('reject')

	if success:
		if (action.has('karma')):
			nomad.karma(action['karma'])

		if (action.has('money')):
			var money = action['money']
			if money > 0:
				money = money * nomad.location.bonus

			nomad.money(money)

		if (action.has('mood')):
			nomad.mood(action['mood'])

		if (action.has('pet')):
			var pets = {
				'cat': [Modifiers.Pet.Cat, $Status/Actions/Pet/Cat],
				'dog': [Modifiers.Pet.Dog, $Status/Actions/Pet/Dog],
			}

			nomad.pet = pets[action['pet']][0].new()
			pets[action['pet']][1].show()

		nomad.rating(+1)
	else:
		nomad.rating(-1)
		nomad.mood(-1)

	print('Action: %s' % action)

	if not (action.has('skip') && action['skip']):
		current_card.done = true

	current_card = null
	$Card.hide()

	if blackout:
		$Blackout/Label.hide()
		$Blackout.show()
		$Blackout/Fade.play('Fade')
		yield($Blackout/Fade, 'animation_finished')

		$Blackout/Label.text = 'Tick... Tock...'
		$Blackout/Label.show()
		yield(get_tree().create_timer(3.0), 'timeout')
		$Blackout/Label.hide()

	if (action.has('time')):
		self.tick(time_cost)
		nomad.energy(-energy_cost)
		nomad.hunger(-action['time'])

	if blackout:
		$Blackout/Fade.play_backwards('Fade')
		yield($Blackout/Fade, 'animation_finished')
		$Blackout.hide()

	emit_signal('card_closed')

func click_exit(node: Node):
	if current_card or $Workstation.visible:
		return

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
		next = [Modifiers.Location.Mongolia.new(), $Locations/Mongolia]

	if node.name == 'Mongolia':
		cost = 3000

		if nomad.money < cost:
			self.error('I don\'t have enough money to leave this place. I need about $3k I think.')
			return

		self.confirm('I think I\'m ready to leave now. Pay and ride the horses to Moscow?')
		action = yield(self, 'confirm_closed')
		if action == 'cancel':
			return

		message = 'Heading to Moscow'
		next = [Modifiers.Location.Moscow.new(), $Locations/Moscow]

	if node.name == 'Moscow':
		cost = 10000

		if nomad.money < cost:
			self.error('Not enough money to leave right now. I think I need about $10k')
			return

		self.confirm('Okay I\'m ready to leave now, I think.. Pay and take the train to Spain?')
		action = yield(self, 'confirm_closed')
		if action == 'cancel':
			return

		message = 'Heading to Spain'
		next = [Modifiers.Location.Spain.new(), $Locations/Spain]

	if node.name == 'Spain':
		cost = 20000

		if nomad.money < cost:
			self.error('I need more cash to leave to New York, about $20k I think')
			return

		self.confirm('I think I\'m ready to go. Pay and board the plane to New York?')
		action = yield(self, 'confirm_closed')
		if action == 'cancel':
			return

		message = 'All the way to New York'
		next = [Modifiers.Location.NewYork.new(), $Locations/NewYork]

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
	nomad.location = next[0]

	node.hide()
	next[1].show()

	$BackgroundAudio.stream = load("res://assets/sound/bgm/%s.ogg" % next[0].slug)
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
	if current_card or $Workstation.visible:
		return

	print('Mood clicked in %s' % node.name)
	var message
	var cost

	match node.name:
		'Pyongyang':
			message = 'You praise THE LEADER. Your mood doesn\'t seem to have improved.'
			self.tick(1)
		'Mongolia':
			cost = 5
			if nomad.money < cost:
				self.error('I need $5 to shoot some arrows.')
				return

			message = 'Pew pew! Pew pew pew pew! This was fun.'
			nomad.mood(+25)
			nomad.money(-cost)
			self.tick(1)
		'Moscow':
			cost = 20
			if nomad.money < cost:
				self.error('I need $20 to get some vodka.')
				return

			message = 'Laaaaaaaaaaalalalalalalala. Ugh.'
			nomad.mood(+25)
			nomad.health(-5)
			nomad.money(-cost)
			self.tick(2)
		'Spain':
			cost = 50
			if nomad.money < cost:
				self.error('I need $50 to get in.')
				return

			message = 'Hmm. This looks nice.'
			nomad.mood(+25)
			nomad.money(-cost)
			self.tick(1)
		'NewYork':
			cost = 200
			if nomad.money < cost:
				self.error('I need at least $200 to get in this place.')
				return

			message = 'Hello ladies...'
			nomad.mood(+25)
			nomad.money(-cost)
			self.tick(4)

	$Blackout.show()
	$Blackout/Fade.play('Fade')
	yield($Blackout/Fade, 'animation_finished')

	$Blackout/Label.text = message
	$Blackout/Label.show()
	yield(get_tree().create_timer(3.0), 'timeout')
	$Blackout/Label.hide()

	$Blackout/Fade.play_backwards('Fade')
	yield($Blackout/Fade, 'animation_finished')
	$Blackout.hide()

func click_tech(node: Node):
	if current_card or $Workstation.visible:
		return

	print('Tech clicked in %s' % node.name)

	var tech = nomad.location.tech.new()
	var action

	if tech.name == nomad.workstation.name:
		self.error('I already have a %s. They don\'t sell anything better here.' % tech.name)
		return

	if tech.cost > nomad.money:
		self.error('Can\'t afford this new tech right now. I need $%d at least' % tech.cost)
		return

	self.confirm('I can buy a brand new %s here, it seems, for $%d. I wonder if I should do it. It may help me work faster.' % [tech.name, tech.cost])
	action = yield(self, 'confirm_closed')
	if action == 'cancel':
		return

	nomad.money(-tech.cost)
	nomad.mood(20)
	nomad.health(10)
	nomad.workstation = tech

	self.tick(1)
	self.success('New workstation, perfect.')

func meow():
	if randf() > 0.9:
		play('meow')

func woof():
	if randf() > 0.9:
		play('woof')
