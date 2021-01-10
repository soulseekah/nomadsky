extends Node

signal card_closed
signal quiz_closed

class_name Main

var time: float
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
	nomad.hunger = 80
	nomad.mood = 80
	nomad.rating = 0

	location = Modifiers.Location.Pyongyang.new()
	actions = [$Card/Action1, $Card/Action2, $Card/Action3]
	
	$Actions.hide()
	$Workstation.hide()
	
	$Actions/Work.connect('pressed', self, 'workstation_open')
	$Actions/Sleep.connect('pressed', self, 'sleep')
	$Actions/Eat.connect('pressed', self, 'eat')
	
	$Workstation/Actions/Shutdown.connect('pressed', self, 'workstation_close')
	$Workstation/Actions/Work.connect('pressed', self, 'find_work')

	$Workstation/Actions/Courses.connect('pressed', self, 'show_courses')
	$Workstation/Courses/Cancel.connect('pressed', self, 'hide_courses')
	$Workstation/Courses/Submit.connect('pressed', self, 'do_course')
	$Workstation/Courses/Quiz/Submit.connect('pressed', self, 'do_quiz')
	
	$Error/Okay.connect('pressed', self, 'dismiss_error')
	$Success/Okay.connect('pressed', self, 'dismiss_success')
	
	$Card/Action1.connect('pressed', self, 'do_action_1')
	$Card/Action2.connect('pressed', self, 'do_action_2')
	$Card/Action3.connect('pressed', self, 'do_action_3')
	
	nomad.connect('dead', self, 'dead')

	#yield(get_tree().create_timer(3.0), 'timeout')

	# First card
	current_card = Cards.pick(['info'], self)
	self.show_card(current_card)
	
	yield(self, 'card_closed')
	$Actions.show()
	
	var timer = Timer.new()
	timer.set_wait_time(5.0)
	timer.set_one_shot(false)
	timer.connect('timeout', self, 'maybe_pick_card')
	self.add_child(timer)
	timer.start()

	$Timer.text = str(time);

func _process(delta):
	$Timer.text = 'Time: %s' % str(int(time))
	$Stats.text = str(nomad)
	
	if queued_card and self.is_idle():
		current_card = queued_card
		
		if $Workstation.visible:
			$Workstation/Actions.hide()
		else:
			$Actions.hide()
		
		self.show_card(current_card)
		yield(self, 'card_closed')
		queued_card = null
		
		if $Workstation.visible:
			$Workstation/Actions.show()
		else:
			$Actions.show()

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
	
func maybe_pick_card():
	if randf() > 0.9 and not queued_card:
		queued_card = Cards.pick(['info', 'accident', 'gift', 'decision'], self)

func dead(why):
	var reasons = {
		'hunger': 'You so hungry, you so dead.'
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

func error(message: String):
	$Error/Label.text = message
	$Error.show()
	
func success(message: String):
	$Success/Label.text = message
	$Success.show()

func eat():
	var cost = 10

	if nomad.money < cost:
		self.error('You can\'t afford to eat.')
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
	call_deferred('play', 'click1')
	
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
	
	$Card/Text.bbcode_text = '[b]%s[/b]\n\n%s' % [card.title, card.description]

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
	$Actions.hide()

func workstation_close():
	call_deferred('play', 'click2')
	
	if current_card:
		return

	$Workstation.hide()
	$Actions.show()
	
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

	var success: bool = true # TODO: calcs
	
	match action_name:
		'ignore': play('ignore')
		'accept': play('click2')
		'okay': play('ignore')
		'decline': play('reject')

	if (action.has('time')):
		time += action['time']
		nomad.energy(-action['time'] * 2)
		nomad.hunger(-action['time'])

	if success:
		if (action.has('karma')):
			nomad.karma(action['karma'])
			
		if (action.has('money')):
			nomad.money(action['money'])

		if (action.has('mood')):
			nomad.mood(action['mood'])
			
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
