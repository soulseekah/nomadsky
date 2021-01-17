extends Node


var cards: Array = []


func pick(types: Array, main: Main) -> Card:
	var valid = []
	var total = 0
	var skilled

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

			if card.requirements['pet'] == 'cat;dog' and not main.nomad.pet:
				continue

		skilled = true
		for skill in ['code', 'gamedev', 'soft', 'design', 'copywriting']:
			if card.requirements.has(skill) and main.nomad[skill] < card.requirements[skill]:
				skilled = false
				break

		if not skilled:
			continue

		if card.requirements.has('money') and main.nomad.money < card.requirements['money']:
			continue

		if card.requirements.has('location'):
			if card.requirements['location'] == 'spain;newyork' and (main.nomad.location.slug != 'spain' and main.nomad.location.slug != 'newyork'):
				continue
			elif main.nomad.location.slug != card.requirements['location']:
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
			'description': '~ DJT',
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
			'type': 'work',
			'title': 'Flyers for a kids party',
			'description': 'Our budget is low but we\'ll tell the rest of the parents about how good of a designer you are.',
			'chance': 0.5,
			'requirements': {
				'design': 1,
			},
			'actions': {
				'accept': {
					'money': 10,
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
			'title': 'Resize a bunch of photos',
			'description': 'Google Photos is charging me an arm and a leg for my vacation photos. I heard resizing can help bring costs down. Lossless resizing only!',
			'chance': 0.1,
			'requirements': {
				'design': 1,
			},
			'actions': {
				'accept': {
					'money': 90,
					'time': 24,
					'mood': -25,
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
			'title': 'Take photos of our handmade crafts for our website',
			'description': 'We have 200 items to take photos of. 4 sides per product + closup shots. We can only pay for about 8 hours of work total.',
			'chance': 0.6,
			'requirements': {
				'design': 1,
			},
			'actions': {
				'accept': {
					'money': 200,
					'time': 24,
					'mood': -30,
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
			'title': 'Custom tshirt designs',
			'description': 'We need to put our company logos on some tshirts. Our expo is in 2 days so please make haste.',
			'chance': 0.3,
			'requirements': {
				'design': 1,
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
			'title': 'Cut my boyfriend out of these pictures',
			'description': 'We broke up. Please crop/cut out, erase all the photos with him in my iCloud.',
			'chance': 0.1,
			'requirements': {
				'design': 1,
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
			'title': 'Help design milk cartons',
			'description': 'Our cows voiced a lot of concern regarding our current cartons underplaying CDD (cow depression disorder) at milk factories. The union demanded us to rebrand and add awareness.',
			'chance': 0.5,
			'requirements': {
				'design': 2,
			},
			'actions': {
				'accept': {
					'money': 240,
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
			'title': 'Create happy face stickers',
			'description': 'Office morale has to go up. We are thinking of handing out happy stickers and increasing work hours and unpaid overtime perhaps.',
			'chance': 0.1,
			'requirements': {
				'design': 2,
			},
			'actions': {
				'accept': {
					'money': 250,
					'time': 6,
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
			'title': 'Zoom and enhance!',
			'description': 'We require help of an image processing genius. Someone scratched our Mazda and we need to find the perp. Police will not help us.',
			'chance': 0.04,
			'requirements': {
				'design': 2,
			},
			'actions': {
				'accept': {
					'money': 400,
					'time': 20,
					'karma': 10,
				},
				'decline': {
					'karma': -10,
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
			'title': '5 book covers',
			'description': 'We wrote 5 books about business. You can use stock photography but we will not pay extra for it.',
			'chance': 0.3,
			'requirements': {
				'design': 2,
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
			'title': 'Design 3D parts for a plastic gun',
			'description': 'Freedom to protecc!!! Hurrr-durr! MURICA! (_oo_)',
			'chance': 0.1,
			'requirements': {
				'design': 2,
			},
			'actions': {
				'accept': {
					'money': 300,
					'time': 18,
					'karma': -30,
				},
				'decline': {
					'karma': 15,
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
			'title': 'New Tom Cruise Movie poster',
			'description': 'New Scientology mockumentary requires poster. Should be Tray Park-level funny.',
			'chance': 0.5,
			'requirements': {
				'design': 3,
			},
			'actions': {
				'accept': {
					'money': 940,
					'time': 15,
					'karma': 10,
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
			'title': 'COVID animation roll',
			'description': 'We need some animation rolls to go onto screens at our companies worldwide with a COVID virus being killed by ninjas and the headline appearing: "KEEP CALM". Doable?',
			'chance': 0.01,
			'requirements': {
				'design': 3,
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
			'title': 'Interior design',
			'description': 'Now that the Capitol has been destoryed we need everything redesigned interior-wise. This is a matter of national urgency.',
			'chance': 0.04,
			'requirements': {
				'design': 3,
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
			'title': 'Reproductions',
			'description': 'We are opening a copy of the Louvre in the middle of Nevada. We need very accurate reproductions of every single painting it contains. We will provide inter-dimensional translations for our visitors.',
			'chance': 0.3,
			'requirements': {
				'design': 3,
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
			'title': 'New traffic signs for our city',
			'description': 'Kids think traffic signs are no longer hip, no longer flex, no longer yeet. We need to modernize our municipality traffic signs (make them "lit") before them kids get bored.',
			'chance': 0.1,
			'requirements': {
				'design': 3,
			},
			'actions': {
				'accept': {
					'money': 1300,
					'time': 23,
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
		{ # Mixed
			'type': 'work',
			'title': 'Website',
			'description': 'Our company requires a website. Design, code, copy, everything!',
			'chance': 0.001,
			'requirements': {
				'location': 'spain;newyork',
				'design': 3,
				'code': 3,
				'copywriting': 3,
			},
			'actions': {
				'accept': {
					'money': 5300,
					'time': 18,
					'skip': true,
				},
				'decline': {
					'time': 1,
					'skip': true,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Game Jam with us',
			'description': "If you know Godot, you're the right person for our job. Let's meet in Discord.",
			'chance': 0.001,
			'requirements': {
				'location': 'spain;newyork',
				'design': 3,
				'code': 3,
				'copywriting': 3,
			},
			'actions': {
				'accept': {
					'money': 1500,
					'time': 12,
					'skip': true,
				},
				'decline': {
					'time': 1,
					'skip': true,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Make a Facebook clone',
			'description': "We're calling it Asspaper. ASAP.",
			'chance': 0.001,
			'requirements': {
				'location': 'spain;newyork',
				'design': 3,
				'code': 3,
				'copywriting': 3,
			},
			'actions': {
				'accept': {
					'money': 2500,
					'time': 18,
					'skip': true,
				},
				'decline': {
					'time': 1,
					'skip': true,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Help us mine some crypto$$$',
			'description': "You seen the prices? We need your computing power.",
			'chance': 0.001,
			'requirements': {
				'location': 'spain;newyork',
				'design': 3,
				'code': 3,
				'copywriting': 3,
			},
			'actions': {
				'accept': {
					'money': 1500,
					'time': 8,
					'skip': true,
				},
				'decline': {
					'time': 1,
					'skip': true,
				},
				'ignore': {
					'time': 1,
					'skip': true,
				},
			},
		},
		{
			'type': 'work',
			'title': 'Consulting',
			'description': "We need about 24 hours of your time. Our IT team has been fired for not working as a team and we launch tomorrow.",
			'chance': 0.001,
			'requirements': {
				'location': 'spain;newyork',
				'design': 3,
				'code': 3,
				'copywriting': 3,
			},
			'actions': {
				'accept': {
					'money': 7500,
					'time': 24,
					'skip': true,
				},
				'decline': {
					'time': 1,
					'skip': true,
				},
				'ignore': {
					'time': 1,
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
			'requirements': {},
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
			'requirements': {},
			'actions': {
				'okay': {
					'time': 2,
					'mood': -25,
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
					'mood': -40,
					'karma': -5,
					'pet': 'null',
				},
			},
			'sound': 'lostcat',
		},
		{
			'type': 'accident',
			'title': 'HAVE YOU SEEN SPARKY?',
			'description': "Your dog ran away :( You try go finding it to no avail.",
			'chance': 0.01,
			'requirements': {
				'pet': 'dog',
			},
			'actions': {
				'okay': {
					'time': 8,
					'mood': -40,
					'karma': -5,
					'pet': 'null',
				},
			},
			'sound': 'lostdog',
		},
		{
			'type': 'accident',
			'title': 'Spoiled food',
			'description': 'Looks like that food was not that fresh... Puke it out and try again.',
			'chance': 0.08,
			'requirements': {},
			'actions': {
				'okay': {
					'time': 6,
					'mood': -35,
					'health': -10,
					'hunger': -50,
				},
			},
			'sound': 'puke',
		},
		{
			'type': 'accident',
			'title': "Slip n' fall, roll and crawl",
			'description': 'Was it a banana peel? Was it a turd? Nobody knows. But you are quite hurt.',
			'chance': 0.08,
			'requirements': {},
			'actions': {
				'okay': {
					'time': 3,
					'mood': -45,
					'health': -20,
				},
			},
			'sound': 'tumble',
		},
		{
			'type': 'accident',
			'title': 'Your digital wallet has been hacked!',
			'description': 'Luckily, as a nomad, you never keep all your eggs in one basket.',
			'chance': 0.08,
			'requirements': {},
			'actions': {
				'okay': {
					'time': 6,
					'mood': -25,
					'money': -40,
				},
			},
			'sound': 'hack',
		},
		{
			'type': 'accident',
			'title': 'It starts raining!',
			'description': 'Your laptop gets wet. Dry it rice, take it to the repair shop.',
			'chance': 0.01,
			'requirements': {},
			'actions': {
				'okay': {
					'time': 8,
					'mood': -25,
					'money': -100,
				},
			},
			'sound': 'rain',
		},
		{
			'type': 'accident',
			'title': 'Watch out!',
			'description': "You get hit by a car. It's a hit and run. Police might find him... not.",
			'chance': 0.03,
			'requirements': {},
			'actions': {
				'okay': {
					'time': 12,
					'mood': -25,
					'health': -70,
				},
			},
			'sound': 'car',
		},
		{
			'type': 'accident',
			'title': '"Cuff \'em up!"',
			'description': 'Police take you in for squatting. There will be fines...',
			'chance': 0.08,
			'requirements': {},
			'actions': {
				'okay': {
					'time': 8,
					'mood': -50,
					'money': -50,
					'health': -10,
				},
			},
			'sound': 'police',
		},

		# Gifts
		{
			'type': 'gift',
			'title': 'Keep your eyes up.',
			'description': "You just found $10 lying on the floor.",
			'chance': 0.5,
			'actions': {
				'okay': {
					'mood': 50,
					'money': 10,
				},
			},
		},
		{
			'type': 'gift',
			'title': "It's your birthday",
			'description': 'Collect $10 from all around you',
			'chance': 0.05,
			'actions': {
				'okay': {
					'mood': 70,
					'money': 30,
				},
			},
		},
		{
			'type': 'gift',
			'title': 'BTC is up',
			'description': 'Time to unHODL the HODLs.',
			'chance': 0.05,
			'actions': {
				'okay': {
					'mood': 40,
					'money': 1000,
				},
			},
		},
		{
			'type': 'gift',
			'title': 'Godot!',
			'description': 'You discover the greatest gift to mankind.',
			'chance': 0.1,
			'actions': {
				'okay': {
					'mood': 50,
				},
			},
		},
		{
			'type': 'gift',
			'title': 'COVID shot',
			'description': 'Immunize. Neutralize. Prosper.',
			'chance': 0.1,
			'actions': {
				'okay': {
					'health': 50,
				},
			},
		},
		{
			'type': 'gift',
			'title': 'Freelance Awards',
			'description': 'You placed 9th!',
			'chance': 0.1,
			'actions': {
				'okay': {
					'mood': 50,
					'money': 20,
				},
			},
		},
		{
			'type': 'gift',
			'title': 'Allelujah!',
			'description': 'You feel blessed! Things are bound to work out from here onwards.',
			'chance': 0.1,
			'actions': {
				'okay': {
					'mood': 50,
					'karma': 50,
				},
			},
		},
		{
			'type': 'gift',
			'title': '"Dinner\'s on me"',
			'description': 'Your friends treat you to a nice dinner. Yum!',
			'chance': 0.1,
			'actions': {
				'okay': {
					'mood': 50,
					'hunger': -50,
				},
			},
		},
		{
			'type': 'gift',
			'title': 'Unexpected Inheritance!',
			'description': "A rich businessman with your last name died in South Africa. You don't believe it.",
			'chance': 0.05,
			'actions': {
				'okay': {
				},
			},
		},
		{
			'type': 'gift',
			'title': 'Cashback.',
			'description': 'Ka-ching! ',
			'chance': 0.1,
			'actions': {
				'okay': {
					'mood': 50,
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
					'mood': -50,
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
					'mood': -50,
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
					'mood': -50,
				},
				'decline': {
					'mood': -40,
				},
			},
		},
		{
			'type': 'decision',
			'title': 'HYIP get rich quick',
			'description': 'Referral bonus, not an MLM! 1% per hour return!',
			'chance': 0.05,
			'actions': {
				'accept': {
					'time': 14,
					'mood': -30,
					'money': -1500
				},
				'decline': {
					'mood': 5,
					'karma': 10,
				},
			},
		},
		{
			'type': 'decision',
			'title': 'Bad part of town',
			'description': "You're held up at gunpoint and it's not even Brazil. Give them your money?",
			'chance': 0.05,
			'actions': {
				'accept': {
					'time': 2,
					'mood': -100,
					'money': -800
				},
				'decline': {
					'time': 4,
					'health': -40,
					'mood': -100,
					'money': -800
				},
			},
		},
		{
			'type': 'decision',
			'title': 'Facebook notification',
			'description': 'You have a new message! Spend some time on Facebook?',
			'chance': 0.05,
			'actions': {
				'accept': {
					'time': 6,
					'mood': -50,
				},
				'decline': {
					'mood': 25,
					'karma': 10,
				},
			},
		},
		{
			'type': 'decision',
			'title': 'Godot Wild Jam',
			'description': "Looks like you can participate in the next jam. What are you going to do?",
			'chance': 0.05,
			'actions': {
				'accept': {
					'time': 8,
					'mood': 30,
					'karma': 30,
				},
				'decline': {
					'mood': -5,
					'karma': -10,
				},
			},
		},
		{
			'type': 'decision',
			'title': 'Crossing oldies',
			'description': 'An old lady is trying to cross the street. Help her?',
			'chance': 0.05,
			'actions': {
				'accept': {
					'time': 1,
					'mood': 40,
					'karma': 20,
				},
				'decline': {
					'mood': -15,
					'karma': -10,
				},
			},
		},
		{
			'type': 'decision',
			'title': 'The package',
			'description': 'A shady looking man in street asks you to deliver a package for him. It is good money.',
			'chance': 0.05,
			'actions': {
				'accept': {
					'time': 2,
					'money': 1000,
					'karma': -50,
					'health': -20,
				},
				'decline': {
					'mood': 5,
					'karma': 10,
				},
			},
		},
		{
			'type': 'decision',
			'title': 'Price hike',
			'description': "This hotel has ridiculous prices, there's no other place to go but be outside. Accept expensive lodging?",
			'chance': 0.05,
			'actions': {
				'accept': {
					'time': 1,
					'mood': -60,
					'money': -200
				},
				'decline': {
					'time': 8,
					'mood': -15,
				},
			},
		},
		{
			'type': 'decision',
			'title': 'No pets allowed',
			'description': "You won't be able to leave with your pet... unless you pay more for your ticket.",
			'requirements': {
				'location': 'spain'
			},
			'chance': 0.01,
			'actions': {
				'accept': {
					'mood': -20,
					'money': -500
				},
				'decline': {
					'pet': 'null',
					'mood': -85,
					'karma': -15,
				},
			},
		},
		{
			'type': 'decision',
			'title': 'Gooqle',
			'description': "Mr. Nomadsky, come work for us a Cooqle, there's no point in freelancing anymore, is there?",
			'requirements': {
				'location': 'newyork',
				'money': 50000,
			},
			'chance': 1.1,
			'actions': {
				'accept': {
					'money': 200000,
					'end': true,
				},
				'decline': {
					'skip': true,
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
		{
			'type': 'info',
			'title': 'Freedom',
			'description': "$50000 is all it really takes...",
			'chance': 2.0,
			'actions': {
				'okay': {}
			},
			'requirements': {
				'location': 'newyork',
			},
		},
		{
			'type': 'info',
			'title': 'Pets',
			'description': "Pet companions will improve mood",
			'chance': 1.0,
			'actions': {
				'okay': {}
			},
			'requirements': {},
		},
		{
			'type': 'info',
			'title': 'Karma',
			'description': "It's real. Don't do evil.",
			'chance': 1.0,
			'actions': {
				'okay': {}
			},
			'requirements': {},
		},
		{
			'type': 'info',
			'title': 'Death',
			'description': "You lose money - you ded. You lose health - you ded. Simple.",
			'chance': 1.0,
			'actions': {
				'okay': {}
			},
			'requirements': {},
		},
		{
			'type': 'info',
			'title': 'Butterfly effect',
			'description': "Anything you do here will affect the world around you. Choose carefully.",
			'chance': 1.0,
			'actions': {
				'okay': {}
			},
			'requirements': {},
		},
		{
			'type': 'info',
			'title': 'Failure',
			'description': "There's no such thing as 100% success. Be ready to fail at work. Mood, hunger, karma, rating affect success rates.",
			'chance': 1.0,
			'actions': {
				'okay': {}
			},
			'requirements': {},
		},
		{
			'type': 'info',
			'title': 'Rating',
			'description': "Performing work affects your freelancer rating. Don't decline outright.",
			'chance': 1.0,
			'actions': {
				'okay': {}
			},
			'requirements': {},
		},
		{
			'type': 'info',
			'title': 'Soft skills',
			'description': "Who would have thought that people pay more to people they like?",
			'chance': 1.0,
			'actions': {
				'okay': {}
			},
			'requirements': {},
		},
		{
			'type': 'info',
			'title': 'Pets',
			'description': "Don't forget to pet your pet :) they'll love it. Click the icon in the UI to pet ;)",
			'chance': 1.0,
			'actions': {
				'okay': {}
			},
			'requirements': {
				'pet': 'cat;dog',
			},

		},
		{
			'type': 'info',
			'title': 'Location, location, location',
			'description': "Move onward as soon as you can...",
			'chance': 1.0,
			'actions': {
				'okay': {}
			},
			'requirements': {},

		},
		{
			'type': 'info',
			'title': 'Travel budgeting',
			'description': "Be careful when travelling, make sure you have enough money left for your first couple of days at a new location.",
			'chance': 1.0,
			'actions': {
				'okay': {}
			},
			'requirements': {},

		},
		{
			'type': 'info',
			'title': "Don't worry. Be happy.",
			'description': "Mood is important and affects how you work. Keep it up!",
			'chance': 1.0,
			'actions': {
				'okay': {}
			},
			'requirements': {},

		},
	]: cards.append(Card.new(card))

	cards.sort_custom(Cards, 'sort_cards')
