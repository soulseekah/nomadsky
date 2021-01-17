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
			
		if card.requirements.has('pet'):
			if card.requirements['pet'] == '!dog;!cat' and main.nomad.pet:
				continue
			
			if card.requirements['pet'] == 'cat' or card.requirements['pet'] == 'dog':
				if not main.nomad.pet or main.nomad.pet.type != card.requirements['pet']:
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
		{ # No skills
			'type': 'work',
			'title': 'Post my comment to 500 blogs',
			'description': "I'm trying to get people to buy my new game. I need someone to advertise a link to it on gaming blogs. Help!",
			'requirements': {},
			'chance': 0.1,
			'actions': {
				'accept': {
					'money': 60,
					'time': 8,
					'karma': -10,
				},
				'decline': {
					'time': 1,
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
			'title': 'Virtual assistant (visually unimpaired)',
			'description': 'We want to send you images with random letters and numbers. You need to quickly tell us what is writtein them.',
			'requirements': {},
			'chance': 0.1,
			'actions': {
				'accept': {
					'money': 60,
					'time': 8,
					'karma': -10,
				},
				'decline': {
					'time': 1,
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
			'title': 'Easy money.',
			'description': "I will pay you to run some special software on your computer 24/7. It may heat up a bit.",
			'requirements': {},
			'chance': 0.1,
			'actions': {
				'accept': {
					'money': 10,
					'time': 24,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				}
			},
		},
		{
			'type': 'work',
			'title': 'Click ads on my site',
			'description': 'We need someone to click on advertisement links on our sites.',
			'requirements': {},
			'chance': 0.1,
			'actions': {
				'accept': {
					'money': 100,
					'time': 8,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				}
			},
		},
		{
			'type': 'work',
			'title': 'Teach my nana computer basics',
			'description': 'My dear nana keeps getting scammed into buying gift cards for tech support. Teach her some computer basics once and for all.',
			'requirements': {},
			'chance': 0.05,
			'actions': {
				'accept': {
					'money': 200,
					'time': 16,
					'karma': 10,
				},
				'decline': {
					'time': 1,
					'karma': -20,
				},
				'ignore': {
					'time': 1,
					'karma': -1,
					'skip': true,
				}
			},
		},
		{
			'type': 'work',
			'title': "Let me use your Steam account for a bit.",
			'description': 'I need to quickly perform a couple of trades on Steam (skins and items), I need an intermediary account.',
			'requirements': {},
			'chance': 0.03,
			'actions': {
				'accept': {
					'money': 50,
					'time': 2,
					'karma': -10,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				}
			},
		},
		{
			'type': 'work',
			'title': "Help me sell my investment program online",
			'description': 'Message your contacts with amazing opportunities and make them message their contacts.',
			'requirements': {},
			'chance': 0.03,
			'actions': {
				'accept': {
					'money': 30,
					'time': 12,
					'karma': -10,
				},
				'decline': {
					'time': 1,
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
			'title': 'Email a list of people',
			'description': 'I need to send a message to a list of about 7000 email addresses. Use at least 1 new email account per 100 emails sent.',
			'requirements': {},
			'chance': 0.02,
			'actions': {
				'accept': {
					'money': 100,
					'time': 18,
					'karma': -30,
				},
				'decline': {
					'time': 1,
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
			'title': 'Customer support',
			'description': 'We are a dropshipping company. We need sales and customer support done.',
			'requirements': {},
			'chance': 0.05,
			'actions': {
				'accept': {
					'money': 70,
					'time': 13,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				}
			},
		},
		{
			'type': 'work',
			'title': 'Clean up a list of addresses',
			'description': 'I have about 1000 addresses in an Excel file, I need them verified and cleaned up to match the UPS format, please.',
			'requirements': {},
			'chance': 0.04,
			'actions': {
				'accept': {
					'money': 60,
					'time': 8,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				}
			},
		},
		{ # Code
			'type': 'work',
			'title': 'Install a WordPress site',
			'description': 'We need you to setup WordPress on our server.',
			'chance': 0.3,
			'requirements': {
				'code': 1,
			},
			'actions': {
				'accept': {
					'money': 80,
					'time': 2,
				},
				'decline': {
					'time': 1,
					'karma': -1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Optimize my site speed.',
			'description': 'Hello. I have all the most popular acceleration plugins installed on my site, 314 in total, but it is still slow..',
			'chance': 0.6,
			'requirements': {
				'code': 1,
			},
			'actions': {
				'accept': {
					'money': 120,
					'time': 6,
				},
				'decline': {
					'time': 1,
					'karma': -5,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Move our Joomla website from GoDaddy to our own servers...',
			'description': 'The downtimes have been killing our business. We need to move ASAP!!11!',
			'chance': 0.3,
			'requirements': {
				'code': 1,
			},
			'actions': {
				'accept': {
					'money': 80,
					'time': 2,
				},
				'decline': {
					'time': 1,
					'karma': -1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'The site stopped working',
			'description': 'We have no idea why. IMMEDIATE help is required.',
			'chance': 0.3,
			'requirements': {
				'code': 1,
			},
			'actions': {
				'accept': {
					'money': 75,
					'time': 3,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'My printer stopped working',
			'description': 'ATTN: I WILL NOT PAY UPFRONT. Fix it and you will get your money.',
			'chance': 0.3,
			'requirements': {
				'code': 1,
			},
			'actions': {
				'accept': {
					'money': 90,
					'time': 4,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Explain Bitcoin to my family',
			'description': 'I need a real web developer to explain what crypto is. They won\'t believe me, but they should believe someone who looks smart. See you soon.',
			'chance': 0.3,
			'requirements': {
				'code': 1,
			},
			'actions': {
				'accept': {
					'money': 80,
					'time': 2,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Solitaire clone for the command-line',
			'description': 'Management disabled GUIs on our work machines, we only have msdos to work in. We need a saviour to help our time pass at this office.',
			'chance': 0.3,
			'requirements': {
				'code': 2,
			},
			'actions': {
				'accept': {
					'money': 300,
					'time': 5,
					'karma': 5,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Create a CRM backend',
			'description': 'Our face mask and sanitizer company is growing fast. We need a custom-built or exiting CRM system deployed on our premises.',
			'chance': 0.04,
			'requirements': {
				'code': 2,
			},
			'actions': {
				'accept': {
					'money': 400,
					'time': 8,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Write a betting automation suite',
			'description': 'I am looking to automatically bet on certain cricket teams according to a very smart strategy. NDA has to be signed.',
			'chance': 0.3,
			'requirements': {
				'code': 2,
			},
			'actions': {
				'accept': {
					'money': 170,
					'time': 4,
				},
				'decline': {
					'karma': 5,
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Fine-tune self-driving software for our drone',
			'description': 'We are an indie film studio. Some of our drones seem to be misbehaving. Can someone check it out?',
			'chance': 0.3,
			'requirements': {
				'code': 2,
			},
			'actions': {
				'accept': {
					'money': 350,
					'time': 14,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'My former partner screwed us over. HELP!',
			'description': 'We need the help of a "security pro" to help regain access to our servers after a fallout with a disgruntled employee.',
			'chance': 0.3,
			'requirements': {
				'code': 2,
			},
			'actions': {
				'accept': {
					'money': 300,
					'time': 7,
					'karma': -10,
				},
				'decline': {
					'karma': 5,
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Develop 3d printing software',
			'description': 'We need a web-based HTML5-powered 3d printing software done in React. We used Vue for a prototype and it seems to work well. Cheers.',
			'chance': 0.3,
			'requirements': {
				'code': 3,
			},
			'actions': {
				'accept': {
					'money': 700,
					'time': 17,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Root my iPhone.',
			'description': 'I need this hot new game Nomadsky to run on my iPhone. Can has root, pls?',
			'chance': 0.2,
			'requirements': {
				'code': 3,
			},
			'actions': {
				'accept': {
					'money': 345,
					'time': 10,
					'karma': 15,
				},
				'decline': {
					'time': 1,
					'karma': -10,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Setup our server room',
			'description': 'Our bank requires secure servers to be installed to store and process transaction data. Looking for rockstar engineers.',
			'chance': 0.3,
			'requirements': {
				'code': 3,
			},
			'actions': {
				'accept': {
					'money': 800,
					'time': 20,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Write a Linux Driver for a weather station',
			'description': 'We got these home weather stations produced. They are not recognized in Ubuntu machines.',
			'chance': 0.1,
			'requirements': {
				'code': 3,
			},
			'actions': {
				'accept': {
					'money': 600,
					'time': 7,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Move our MySQL database to a Postgres one',
			'description': 'We have been using MySQL for a while now and as our data has grown and demands increased we are looking for a more robust and flexible solution. Rewrite our application to work with psql.',
			'chance': 0.3,
			'requirements': {
				'code': 3,
			},
			'actions': {
				'accept': {
					'money': 800,
					'time': 20,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Reverse engineer this iPhone app',
			'description': 'We want to be able to figure out how a certain iPhone app works. Can anyone help?',
			'chance': 0.3,
			'requirements': {
				'code': 3,
			},
			'actions': {
				'accept': {
					'money': 300,
					'time': 8,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Slippery business.',
			'description': 'I need a website taken down for a bit.... I hear you do that kind of thing...',
			'chance': 0.7,
			'requirements': {
				'code': 3,
			},
			'actions': {
				'accept': {
					'money': 375,
					'time': 12,
					'karma': -20,
				},
				'decline': {
					'time': 1,
					'karma': 10,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{ # Copy
			'type': 'work',
			'title': 'Write 6 articles about cheap hosting services.',
			'description': 'We are a hosting company with a bad rep... we need people to believe us more.',
			'chance': 0.5,
			'requirements': {
				'copywriting': 1,
			},
			'actions': {
				'accept': {
					'money': 140,
					'time': 8,
					'karma': -10,
				},
				'decline': {
					'time': 1,
					'karma': 5,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Set up goals in Google Analytics.',
			'description': 'Set up goals on the site for the sale of original Rolex watches from $11.89',
			'chance': 0.1,
			'requirements': {
				'copywriting': 1,
			},
			'actions': {
				'accept': {
					'money': 30,
					'time': 1,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
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
				'copywriting': 1,
			},
			'actions': {
				'accept': {
					'money': 200,
					'time': 20,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Write some insightful text content for my Instagram posts!',
			'description': 'I am a beautiful girl (that\'s it) and I want more followers.',
			'chance': 0.3,
			'requirements': {
				'copywriting': 1,
			},
			'actions': {
				'accept': {
					'money': 100,
					'time': 4,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Translate my article about essential oil benefits',
			'description': 'Native speakers only. You have until the end of the day.',
			'chance': 0.1,
			'requirements': {
				'copywriting': 1,
			},
			'actions': {
				'accept': {
					'money': 30,
					'time': 2,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Take over editorials on our news website.',
			'description': 'You will need to make sure the writers are doing a solid job every day. We follow local news.',
			'chance': 0.5,
			'requirements': {
				'copywriting': 2,
			},
			'actions': {
				'accept': {
					'money': 340,
					'time': 8,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Write 14 articles about game development impact on society',
			'description': 'Half of them should be negative and half of them positive. We still don\'t fully understand the full impact of this thing kids call #gamedev.',
			'chance': 0.1,
			'requirements': {
				'copywriting': 2,
			},
			'actions': {
				'accept': {
					'money': 300,
					'time': 16,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Write a space exploration manual for KSA',
			'description': 'Our space agency is looking to attract younglings into space exploration and sciences. Looking for diligent writers. Godspeed.',
			'chance': 0.04,
			'requirements': {
				'copywriting': 2,
			},
			'actions': {
				'accept': {
					'money': 400,
					'time': 20,
					'karma': 20,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Rewrite a certain secret field manual on enhanced interrogation techniques.',
			'description': 'Take out all the bad parts, please. Yours, the FBI.',
			'chance': 0.3,
			'requirements': {
				'copywriting': 2,
			},
			'actions': {
				'accept': {
					'money': 500,
					'time': 12,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Help my son with his university essay.',
			'description': 'He is a good buy. Bless his heart. Needs help writing a powerful story (not necessarily "accurate").',
			'chance': 0.1,
			'requirements': {
				'copywriting': 2,
			},
			'actions': {
				'accept': {
					'money': 30,
					'time': 2,
					'karma': -10,
				},
				'decline': {
					'karma': 5,
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Finish a sequel to one of my books.',
			'description': 'This is a ghostwriting assignment. NDA. Thank you. Signed: JKR',
			'chance': 0.5,
			'requirements': {
				'copywriting': 3,
			},
			'actions': {
				'accept': {
					'money': 940,
					'time': 22,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Write the best speech. The best. o_O',
			'description': '~ JDT',
			'chance': 0.01,
			'requirements': {
				'copywriting': 3,
			},
			'actions': {
				'accept': {
					'money': 3000,
					'time': 16,
					'karma': -10,
				},
				'decline': {
					'karma': 5,
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Our popular TV show requires writers',
			'description': 'Humor, drama, action. Send samples when applying.',
			'chance': 0.04,
			'requirements': {
				'copywriting': 3,
			},
			'actions': {
				'accept': {
					'money': 900,
					'time': 20,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Cryptocurrency whitepaper',
			'description': 'We are doing an ICO and our marketing team said we need some sort of "whitepaper". Turns out it is not literally a white piece of paper. Launch is due tomorrow.',
			'chance': 0.3,
			'requirements': {
				'copywriting': 3,
			},
			'actions': {
				'accept': {
					'money': 500,
					'time': 8,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'New York Times',
			'description': 'We are looking for a freelance writer to write about digital nomads and their life during the pandemic. Apply here.',
			'chance': 0.1,
			'requirements': {
				'copywriting': 3,
			},
			'actions': {
				'accept': {
					'money': 300,
					'time': 4,
				},
				'decline': {
					'time': 1,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{ # Design
		}

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
		{
			'type': 'info',
			'title': 'Upgrades',
			'description': "This laptop is barely functioning. Make sure you purchase an upgrades in every new location.",
			'chance': 1.0,
			'actions': {
				'okay': {}
			},
			'requirements': {
				'location': 'mongolia',
			},
		},
	]: cards.append(Card.new(card))
	
	cards.sort_custom(Cards, 'sort_cards')
