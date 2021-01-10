extends Node


var cards: Array = []


func pick(types: Array, main: Main) -> Card:
	var valid = []
	var total = 0

	for card in cards:
		if card.done:
			continue
		
		if types and not card.type in types:
			continue

		if card.requirements.has('time') and card.requirements['time'] > main.time:
			continue

		valid.append(card)
		total += int(card.chance * 1000)
		
	if not valid.front():
		return null
		
	if valid.front().chance >= 1.0:
		return valid.front()

	var choice = (randi() % total) + 1
	for card in valid:
		choice -= int(card.chance * 1000)
		if choice <= 0:
			return card

	return null
	
func sort_cards(a, b):
	return a.chance > b.chance

class Card:
	var type: String # one of work, accident, gift, decision, info

	var title: String
	var description: String
	var chance: float # every card cycle

	var requirements: Dictionary # unlock when

	var actions: Dictionary # one of accept, decline, okay
	var done: bool = false

	var sound: String

	func _init(card):
		type = card['type']
		title = card['title']
		description = card['description']
		chance = card['chance']
		actions = card.get('actions', {})

		requirements = card.get('requirements', {})
		
		if card.get('sound'):
			sound = card.get('sound')

	func _to_string():
		return '[%s] %s (done: %s)' % [type, title, done]


func _ready():
	for card in [
		# Work
		{
			'type': 'work',
			'title': 'Post my comment to 500 blogs',
			'description': "I'm trying to get people to buy my new game. I need someone to advertise a link to it on gaming blogs. Help!",
			'chance': 0.1,
			'actions': {
				'accept': {
					'money': 60,
					'time': 8,
					'karma': -10,
				},
				'decline': {
					'karma': 5,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				}
			},
		},
		{
			'type': 'work',
			'title': 'Install a WordPress site',
			'description': 'We need you to setup WordPress on our server.',
			'chance': 0.3,
			'requirements': {
				'code': 1,
			},
			'actions': {
				'accept': {
					'money': 20,
					'time': 2,
				},
				'decline': {
					'karma': -1,
				},
				'ignore': {
					'skip': true,
				},
			},
		},

		# Accidents
		{
			'type': 'accident',
			'title': 'Battery 0%',
			'description': 'Your laptop battery is flat. Go find a charger!',
			'chance': 0.1,
			'requirements': {
				'quarters': 'camping',
			},
			'actions': {
				'okay': {
					'time': 8,
					'rating': -1,
				},
			},
			'sound': 'lowbat',
		},
		{
			'type': 'accident',
			'title': 'Lights out!',
			'description': "Another electricity blackout :( you won't be able to work for a while.",
			'chance': 0.05,
			'requirements': {
				'quarters': '!camping',
			},
			'actions': {
				'okay': {
					'time': 2,
					'mood': -5,
				},
			},
			'sound': 'blackout',
		},
		{
			'type': 'accident',
			'title': 'Here kitty-kitty-kitty-kitty...',
			'description': "Your cat ran away :( You try go finding it to no avail.",
			'chance': 0.01,
			'requirements': {
				'pet': 'cat',
			},
			'actions': {
				'okay': {
					'time': 8,
					'mood': -10,
					'karma': -5,
				},
			},
			'sound': 'lostcat',
		},

		# Gifts
		{
			'type': 'gift',
			'title': 'Keep your eyes up.',
			'description': "You just found $10 lying on the floor.",
			'chance': 0.5,
			'actions': {
				'okay': {
					'mood': 5,
					'money': 10,
				},
			},
		},

		# Decisions
		{
			'type': 'decision',
			'title': 'Meow!',
			'description': 'This small kitten is hungry and cold... Why not make it your pet?',
			'chance': 0.2,
			'requirements': {
				'pet': '!dog;!cat',
			},
			'actions': {
				'accept': {
					'karma': 5,
					'pet': 'cat',
				},
				'decline': {
					'karma': -20,
					'mood': -5,
				},
			},
			'sound': 'meow',
		},
		{
			'type': 'decision',
			'title': 'Woof! Woof!',
			'description': 'This homeless dog is lost. Would you like to adopt it?',
			'chance': 0.25,
			'requirements': {
				'pet': '!dog;!cat',
			},
			'actions': {
				'accept': {
					'karma': 5,
					'pet': 'dog',
				},
				'decline': {
					'karma': -10,
					'mood': -10,
				},
			},
			'sound': 'woof',
		},
		{
			'type': 'decision',
			'title': 'dota2.exe',
			'description': 'Your mates are calling you for a game of Dotes.',
			'chance': 0.05,
			'actions': {
				'accept': {
					'time': 4,
					'mood': -10,
				},
				'decline': {
					'mood': -1,
				},
			},
			'sound': 'dota',
		},

		# Tutorial
		{
			'type': 'info',
			'title': 'The Motherland bears Opportunity',
			'description': "Pssst! I heard you were looking for a laptop. Don't tell anyone, and use VPN.",
			'chance': 2.0,
			'actions': {
				'okay': {
					'workstation': 'red',
					'money': -80,
				},
			},
			'sound': 'psst',
		},
		{
			'type': 'info',
			'title': 'Courses',
			'description': "Hey, don't forget to level up your skills, mate. Click the courses icon on your laptop.",
			'chance': 1.0,
			'actions': {
				'okay': {}
			},
			'requirements': {
				'time': 24,
			},
		},
	]: cards.append(Card.new(card))
	
	cards.sort_custom(Cards, 'sort_cards')
