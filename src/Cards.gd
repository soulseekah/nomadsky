extends Node


var cards: Array = []


func pick(type: String) -> Card:
	cards.shuffle()
	return cards.front()


class Card:
	var type: String # one of work, accident, gift, decision

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
		requirements = card['requirements']
		actions = card['actions']

		if card.get('sound'):
			sound = card['sound']

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
			'requirements': {},
			'actions': {
				'accept': {
					'money': 50,
					'time': 8,
					'karma': -10,
				},
				'decline': {
					'karma': 5,
				},
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
			'requirements': {},
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
	]: cards.append(Card.new(card))
