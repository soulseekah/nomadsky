extends Node

func available(main: Main) -> Array:
	var valid = []
	courses.shuffle()

	for course in courses:
		if course.done:
			continue
		
		if course.level != (main.nomad[course.type] + 1):
			continue
		
		valid.append(course)
		if valid.size() >= 3:
			break

	return valid

var courses: Array = []

class Course:
	var name: String
	var type: String
	var done: bool
	var level: int

	var cost: int

	var quizzes: Array = []

	class Quiz:
		var question: String
		var answer: String
		var filler: Array

		func _init(quiz):
			question = quiz['question']
			answer = quiz['answer']
			filler = quiz['filler']

	func _init(course):
		name = course['name']
		type = course['type'] # copywriting, design, code, soft, gamedev
		cost = course['cost']
		level = course['level']
		done = false

		for quiz in course.quiz:
			quizzes.append(Quiz.new(quiz))
	
	func pick_quiz():
		self.quizzes.shuffle()
		return self.quizzes.front()
	
	func _to_string():
		return '[%s] %s $%d' % [type, name, cost]


func _ready():
	for course in [
		{
			'name': 'Beginner Level English: Hello', 'type': 'copywriting', 'cost': 7, 'level': 1,
			'quiz': [
				{
					'question': 'What is the plural of cat?', 'answer': 'cats',
					'filler': ['cattes', 'chats'],
				},
				{
					'question': 'What punctuation mark is placed at the end of a sentence?', 'answer': 'dot',
					'filler': ['comma', 'bot'],
				},
				{
					'question': 'How many mistakes can you make in your texts?', 'answer': '0',
					'filler': ['1', '001010'],
				},
			],
		},
		{
			'name': 'Intermediate Level English: Greetings', 'type': 'copywriting', 'cost': 15, 'level': 2,
			'quiz': [
				{
					'question': 'What html tag is used to wrap the first title in the text?', 'answer': 'h1',
					'filler': ['1h', '1inch'],
				},
				{
					'question': 'In what case should you write the first character in a sentence?', 'answer': 'uppercase',
					'filler': ['top', 'high'],
				},
				{
					'question': 'What should your text be generously sprinkled with?', 'answer': 'keywords',
					'filler': ['advertising', 'referral links'],
				},
			],
		},
		{
			'name': 'God Level English: ‘Ello, gov’nor!', 'type': 'copywriting', 'cost': 30, 'level': 3,
			'quiz': [
				{
					'question': 'How often should a keyword appear in the text?', 'answer': 'every word should be key',
					'filler': ['every other word', 'just once'],
				},
				{
					'question': 'Is it worth buying 10,000 links to your post?', 'answer': 'yes',
					'filler': ['only after consulting your roommate', 'depends on how much they cost'],
				},
				{
					'question': 'What is Google\'s tool for webmasters called?', 'answer': 'Search Console',
					'filler': ['Google Webmaster', 'Amigo browser'],
				},
			],
		},
		{
			'name': 'Beginner Gamedev: Elon Musk', 'type': 'gamedev', 'cost': 7, 'level': 1,
			'quiz': [
				{
					'question': "What's the name of Mario's brother?", 'answer': 'Luigi',
					'filler': ['Super Mario', 'that green dude'],
				},
				{
					'question': 'What is the best game of all?', 'answer': 'this game',
					'filler': ['wrong answer', '---'],
				},
				{
					'question': 'In the production of which game was Keanu Reeves actively involved?', 'answer': 'Cyberpunk 2077',
					'filler': ['Mission Impossible', 'Superdrunk 2021'],
				},
			],
		},
		{
			'name': 'Intermediate Gamedev: Hello Games', 'type': 'gamedev', 'cost': 15, 'level': 2,
			'quiz': [
				{
					'question': "What's the name of the lady who's always raiding tombs?", 'answer': 'Lara Croft',
					'filler': ['Angelina Jolie', 'Marge Simpson'],
				},
				{
					'question': 'Which is the best open-source game engine?', 'answer': 'Godot',
					'filler': ["Unity", 'Allegro'],
				},
				{
					'question': 'What is E3?', 'answer': 'a conference to show your prerenders at',
					'filler': ['a video card', 'the sequel to The Three Musketeers'],
				},
			],
		},
		{
			'name': 'God Level Gamedev: GabeN', 'type': 'gamedev', 'cost': 30, 'level': 3,
			'quiz': [
				{
					'question': 'Are mirrors hard to implement?', 'answer': 'yes',
					'filler': ['sure', 'absolutely'],
				},
				{
					'question': 'Who gets fresh meat with a hook?', 'answer': 'Pudge',
					'filler': ['Hoodwink', 'Donald Crab'],
				},
				{
					'question': 'What happens if you defuse a bomb?', 'answer': 'counter terrorist win',
					'filler': ['you will receive a state award', "you'll be a hero"],
				},
			],
		},
		{
			'name': 'Photoshop.exe', 'type': 'design', 'cost': 7, 'level': 1,
			'quiz': [
				{
					'question': 'What does the alpha value denote?', 'answer': 'opacity',
					'filler': ["it's the currency in Zambia", 'how much of a man one is'],
				},
				{
					'question': 'What color are taxies usually?', 'answer': 'yellow',
					'filler': ['azure', 'like Skittles'],
				},
				{
					'question': 'What does the abbreviation RGB mean?', 'answer': 'red green blue',
					'filler': ['rarely green boys', "risotto wth gaspaccio bacon, please"],
				},
			],
		},
		{
			'name': 'Asperite', 'type': 'design', 'cost': 15, 'level': 2,
			'quiz': [
				{
					'question': 'What should pixel art never contain?', 'answer': 'double pixels',
					'filler': ['colour', 'pixels'],
				},
				{
					'question': 'How many shades of absolute black are there?', 'answer': 'just the one',
					'filler': ['3brg', '10000rgb'],
				},
				{
					'question': 'What is a gradient?', 'answer': 'gradual change in color',
					'filler': ['pedestrians crossing', 'one who applies to 50 Shades of Gray philosophies'],
				},
			],
		},
		{
			'name': 'hexdump to .asperite', 'type': 'design', 'cost': 30, 'level': 3,
			'quiz': [
				{
					'question': 'How many shades of gray are there in 50 Shades of Gray?', 'answer': '50',
					'filler': ['1', 'I only remember the red room'],
				},
				{
					'question': 'Is there an arrow on the Fedex logo?', 'answer': 'yes',
					'filler': ['now I see it', "there are actually 5 of them"],
				},
				{
					'question': 'What are Bezier curves?', 'answer': 'mathematically-described curves in space',
					'filler': ['the shortest distance from points A to B', 'this guy Bezier had a really nice body'],
				},
			],
		},
		{
			'name': 'Beginner: ^(*.?)$', 'type': 'code', 'cost': 7, 'level': 1,
			'quiz': [
				{
					'question': 'What is the name of the longest key on the keyboard?', 'answer': 'the space bar',
					'filler': ['the galaxy pub', 'F13'],
				},
				{
					'question': 'What does HTML stand for?', 'answer': 'hypertext markup language',
					'filler': ["it's not a programming language", 'hold the machine learning'],
				},
				{
					'question': 'What are PCREs?', 'answer': 'Perl-compatible regular expressions',
					'filler': ['poopy-crap rectal exhaust', 'processor-complete reverse engineering'],
				},
			],
		},
		{
			'name': 'Intermediate: Darknet', 'type': 'code', 'cost': 15, 'level': 2,
			'quiz': [
				{
					'question': 'Which programming language hisses?', 'answer': 'C++',
					'filler': ['Reptile', 'Python']
				},
				{
					'question': 'As a programmer, would you develop a computer game?', 'answer': 'no',
					'filler': ['yeah, Ill make a lot of money lol', 'yes, I wont earn anything =('],
				},
				{
					'question': "You've been working all day and you're hungry. Best course of action?", 'answer': 'order a pizza',
					'filler': ['cook a 3-course meal', 'ignore everything, keep working'],
				},
			],
		},
		{
			'name': 'God Level: 0x29efebb39e5cbaf0e8', 'type': 'code', 'cost': 30, 'level': 3,
			'quiz': [
				{
					'question': 'How many processors are there in an 8 core processor?', 'answer': '1',
					'filler': ['8', '16'],
				},
				{
					'question': '11010001101001111111 + 1', 'answer': '11010001101010000000',
					'filler': ['110100011010011111111', 'integer overflow'],
				},
				{
					'question': 'What architecture does the Raspberry Pi function on?', 'answer': 'arm',
					'filler': ['amd', 'x86'],
				},
			],
		},
		{
			'name': 'Softskills: 101', 'type': 'soft', 'cost': 7, 'level': 1,
			'quiz': [
				{
					'question': 'Your mechanical keyboard woke the neighbours up.', 'answer': 'Apologize profusely, promising new o-rings',
					'filler': ["Keep the door shut and pretend you're not there", 'Confrontationally send them back where they came from'],
				},
				{
					'question': 'A dead Nigerian prince wants to deliver your gold ineritance.', 'answer': "It's fake!",
					'filler': ['Travel to Nigeria to meet his laywers', 'Take care of all transaction fees upfront.'],
				},
				{
					'question': 'A co-worker is acting like an asshole', 'answer': 'Voice your concerns privately, work it out',
					'filler': ['Set her up and get her fired', "Call her out publically, while keeping her in a wrestling chokehold"],
				},
			],
		},
		{
			'name': 'Softskills: 201', 'type': 'soft', 'cost': 15, 'level': 2,
			'quiz': [
				{
					'question': 'You have more work than you can handle...', 'answer': "Don't bite more than you can't chew",
					'filler': ['Outsource, outsource, outsource', 'Take it on, sleep less, drink more, fail half'],
				},
				{
					'question': 'Tip your Eats courier:', 'answer': '$1.00',
					'filler': ['"Don\'t do anything till you know you\'re ready"', '"Delete your lawyer, hit the Facebook, buy a gym"'],
				},
				{
					'question': 'Your friend tells you about this new cryptocurrency HYIP with 1% returns/day.', 'answer': "Say you're broke",
					'filler': ['Invest 30% of your savings', 'Treat her with some anti-MLM essential oils'],
				},
			],
		},
		{
			'name': 'Skills softer than Vicuna wool', 'type': 'soft', 'cost': 30, 'level': 3,
			'quiz': [
				{
					'question': 'You need to pee. Real hard. The queue is huge.', 'answer': 'Stand on a table and announce the problem, the reprecussions, the solution.',
					'filler': ["Pee ya' pants.", "Pretend to be an employee of this place and use the management's toilet"],
				},
				{
					'question': 'Making a friends is easy:', 'answer': 'name repetition, personality mirroring and never breaking off a handshake',
					'filler': ['jump to conclusions, complain and interrupt', 'keep quiet and just listen, listen, listen'],
				},
				{
					'question': 'What kind of bear is best?', 'answer': 'False! Black bear.',
					'filler': ["That's a ridculous question.", 'There are basically two schools of thoughts...'],
				},
			],
		},
	]: courses.append(Course.new(course))
