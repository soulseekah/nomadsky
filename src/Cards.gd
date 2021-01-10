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
		
		{
		'type': 'work',
			'title': 'Put up 1000 ads in the city',
			'description': 'Need to put up 1000 ads for a recently opened store.',
			'chance': 0.1,
			'actions': {
				'accept': {
					'money': 20,
					'time': 6,
				},
				'ignore': {
					'skip': true,
				},
			},
		},
		
		{
			'type': 'work',
			'title': 'Write 6 advertising articles about cheap hosting services.',
			'description': 'It is necessary to increase traffic to the sites of bad hosting companies.',
			'chance': 0.5,
			'requirements': {
				'code': 1,
				'copywriting': 2,
				'Design':1,
			},
			'actions': {
				'accept': {
					'money': 140,
					'time': 8,
				},
				'decline': {
					'karma': -10,
				},
				'ignore': {
					'skip': true,
				},
			},
		},

		{
			'type': 'work',
			'title': 'Hi. My website doesnt work! =(.',
			'description': 'I bought a Rolex for $11.89 and now my website is giving out a 500 error.',
			'chance': 0.1,
			'requirements': {
				'code': 2,
			},
			'actions': {
				'accept': {
					'money': 50,
					'time': 2,
				},
				'decline': {
					'karma': +5,
				},
				'ignore': {
					'skip': true,
				},
			},
		},
		
		{
			'type': 'work',
			'title': 'Set up goals in google Analytics.',
			'description': 'Set up goals on the site for the sale of original Rolex for $11.89.',
			'chance': 0.1,
			'requirements': {
				'code': 2,
			},
			'actions': {
				'accept': {
					'money': 30,
					'time': 1,
				},
				'decline': {
					'karma': -30,
				},
				'ignore': {
					'skip': true,
				},
			},
		},

{
			'type': 'work',
			'title': 'Set up goals in google Analytics.',
			'description': 'Record a positive video review of the Original Rolex for $11.89',
			'chance': 0.4,
			'requirements': {
				'copywriting': 2
			},
			'actions': {
				'accept': {
					'money': 30,
					'time': 1,
				},
				'decline': {
					'karma': -30,
				},
				'ignore': {
					'skip': true,
				},
			},
		},
		
		
		{
			'type': 'work',
			'title': 'Make 13 simple landing pages as FAST as POSSIBLE!.',
			'description': 'I sell handmade paper airplanes and want to fully occupy a niche.',
			'chance': 0.6,
			'requirements': {
				'code': 2,
				'copywriting': 1,
				'Design':1,
			},
			'actions': {
				'accept': {
					'money': 200,
					'time': 10,
				},
				'decline': {
					'karma': 0,
				},
				'ignore': {
					'skip': true,
				},
			},
		},
		
		{
			'type': 'work',
			'title': 'Elderly lady Eduard Panasyuk asks for help.',
			'description': 'Need to move the lady across the road... 19 times O_O... Come on, dont be gnilushka.',
			'chance': 0.1,
			'actions': {
				'accept': {
					'money': 10,
					'time': 4,
				},
				'decline': {
					'karma': +30,
				},
				'ignore': {
					'skip': true,
				},
			},
		},

		{
			'type': 'work',
			'title': 'Beautifully design a showcase on Instagram.',
			'description': 'Im just a beautiful girl and I want more followers.',
			'chance': 0.3,
			'requirements': {
				'copywriting': 1,
				'Design':2,
			},
			'actions': {
				'accept': {
					'money': 100,
					'time': 4,
				},
				'decline': {
					'karma': 0,
				},
				'ignore': {
					'skip': true,
				},
			},
		},

{
			'type': 'work',
			'title': 'The website acceleration.',
			'description': 'Hello. I have all the most popular acceleration plugins installed on my site, 314 in total, but it is still slow..',
			'chance': 0.6,
			'requirements': {
				'code': 2,
			},
			'actions': {
				'accept': {
					'money': 120,
					'time': 6,
				},
				'decline': {
					'karma': +2,
				},
				'ignore': {
					'skip': true,
				},
			},
		},

		{
			'type': 'work',
			'title': 'Temporary pizza boy.',
			'description': 'The courier had lunch at our restaurant and got food poisoning. We need someone who will be able to deliver the orders',
			'chance': 0.1,
			'actions': {
				'accept': {
					'money': 40,
					'time': 12,
				},
				'decline': {
					'karma': -20,
				},
				'ignore': {
					'skip': true,
				},
			},
		},
		
		{
			'type': 'work',
			'title': 'Help a neighbor.',
			'description': 'Hi Im your neighbor. I have a blown light bulb in my room, I would change it myself, but Im afraid of heights!=( Will you help? ps: grab the ladder.',
			'chance': 0.1,
			'actions': {
				'accept': {
					'money': 10,
					'time': 1,
				},
				'decline': {
					'karma': +10,
				},
				'ignore': {
					'skip': true,
				},
			},
		},
		
		{
			'type': 'work',
			'title': 'Slippery business.',
			'description': 'I need some website not to work all day. I hear you do that kind of thing...',
			'chance': 0.7,
			'requirements': {
				'code': 3,
			},
			'actions': {
				'accept': {
					'money': 375,
					'time': 12,
				},
				'decline': {
					'karma': -40,
				},
				'ignore': {
					'skip': true,
				},
			},
		},

		{
			'type': 'work',
			'title': 'Compress images on the site.',
			'description': 'So the thing requires some modern image formats. Will you do it?',
			'chance': 0.1,
			'requirements': {
				'code': 1,
			},
			'actions': {
				'accept': {
					'money': 30,
					'time': 3,
				},
				'decline': {
					'karma': +10,
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
