extends Node

func available(main: Main) -> Array:
	var valid = []
	courses.shuffle()

	for course in courses:
		if course.done:
			continue
		
		# TODO: Requirements
		
		valid.append(course)
		if valid.size() >= 3:
			break

	return valid

var courses: Array = []

class Course:
	var name: String
	var type: String
	var done: bool

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
			'name': 'Beginner Level English: Hello', 'type': 'copywriting', 'cost': 7,
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
					'question': 'How many mistakes can you make in a text (write a number)?', 'answer': '0',
					'filler': ['1', '001010'],
				},
			],
		},
		{
			'name': 'Intermediate Level English: Greetings', 'type': 'copywriting', 'cost': 15,
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
					'question': 'What should be added after each word in the text?', 'answer': 'keyword',
					'filler': ['advertising', 'referral link'],
				},
			],
		},
		{
			'name': 'God Level English: ‘Ello, gov’nor!', 'type': 'copywriting', 'cost': 30,
			'quiz': [
				{
					'question': 'How often should the keyword appear in the text?', 'answer': 'constantly',
					'filler': ['after each word', 'once'],
				},
				{
					'question': 'Is it worth buying 10,000 links to your post?', 'answer': 'yes',
					'filler': ['need to consult with roommate', "you still haven't bought them?"],
				},
				{
					'question': 'What is the name of the Google tool for webmasters?', 'answer': 'search console',
					'filler': ['webmaster', 'amigo browser'],
				},
			],
		},
		{
			'name': 'Beginner Gamedev: ____', 'type': 'gamedev', 'cost': 7,
			'quiz': [
				{
					'question': "What's the name of Mario's brother?", 'answer': 'Luigi',
					'filler': ['Mario', 'that green dude'],
				},
				{
					'question': 'What is the best game of all?', 'answer': 'this game',
					'filler': ['wrong answer', "why haven't answered yet?"],
				},
				{
					'question': 'In the production of which game was Keanu Reeves actively involved?', 'answer': 'cyberpunk 2077',
					'filler': ['matrita', 'superdrunk 2021'],
				},
			],
		},
		{
			'name': 'Intermediate Gamedev: Hello Games', 'type': 'gamedev', 'cost': 15,
			'quiz': [
				{
					'question': "What's the name of the lady who's always raiding tombs?", 'answer': 'Lara Croft',
					'filler': ['Angelina Jolie', 'Marge Simpson'],
				},
				{
					'question': 'If you were developing a game now, what would be the deadline?', 'answer': 'january 29',
					'filler': ["early access, I'll finish it later", 'july 29'],
				},
				{
					'question': 'What should you do if you are being chased by a zombie?', 'answer': 'to kill him',
					'filler': ['say hello', 'invite him to become a tester'],
				},
			],
		},
		{
			'name': 'God Level Gamedev: Gaben', 'type': 'gamedev', 'cost': 30,
			'quiz': [
				{
					'question': 'At what stage in the development of a game in early access should you finish working on it?', 'answer': 'early access',
					'filler': ['when game is done', 'at release stage'],
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
			'name': 'Design: Bigginer', 'type': 'design', 'cost': 7,
			'quiz': [
				{
					'question': 'What color should the text be?', 'answer': 'black on white background',
					'filler': ['white on white background', 'red - you should read this'],
				},
				{
					'question': 'What color is the taxi?', 'answer': 'yellow',
					'filler': ['azure', 'like skittles'],
				},
				{
					'question': 'What does the abbreviation rgb mean?', 'answer': 'red green blue',
					'filler': ['robot good bot', "risotto gazpacho bacon"],
				},
			],
		},
		{
			'name': 'Design: Cool lvl', 'type': 'design', 'cost': 15,
			'quiz': [
				{
					'question': 'You want to place an image 4000x3000px what should I do with it?', 'answer': 'to reduce',
					'filler': ['nothing', 'apply a beautiful filter'],
				},
				{
					'question': 'How many shades of absolute black are there?', 'answer': '1',
					'filler': ['3brg', '10000rgb'],
				},
				{
					'question': 'What is a gradient?', 'answer': 'switching from one color to another',
					'filler': ['pedestrian crossing', "both"],
				},
			],
		},
		{
			'name': 'Gangsta of design', 'type': 'design', 'cost': 30,
			'quiz': [
				{
					'question': 'What popular color scheme is used for correction?', 'answer': 'orange-blue',
					'filler': ['blue light-blue dark-blue', 'blue. Why do something else?'],
				},
				{
					'question': 'How many shades of gray are there in 50 shades of gray?', 'answer': '50',
					'filler': ['1', 'I only remember the red room'],
				},
				{
					'question': 'Is there an arrow on the Fedex logo?', 'answer': 'yes',
					'filler': ['no', "there are 5 of them"],
				},
			],
		},
		{
			'name': 'Beginner Dev: #;$', 'type': 'code', 'cost': 7,
			'quiz': [
				{
					'question': 'What is the name of the longest key on the keyboard?', 'answer': 'space',
					'filler': ['a', 'f13'],
				},
				{
					'question': 'What is the name of the text markup language?', 'answer': 'html',
					'filler': ['jaga', 'nomadsky'],
				},
				{
					'question': 'What is the main thing in a computer after the CPU?', 'answer': 'to make it work',
					'filler': ['heating for the cup', "enternet connection"],
				},
			],
		},
		{
			'name': 'Intermediate Dev: Hello Darknet', 'type': 'code', 'cost': 15,
			'quiz': [
				{
					'question': 'What programming language is like a snake?', 'answer': 'python',
					'filler': ['worm', 'crocodile'],
				},
				{
					'question': 'As a programmer, would you develop a computer game?', 'answer': 'no',
					'filler': ['yeah, Ill make a lot of money lol', 'yes, I wont earn anything =('],
				},
				{
					'question': 'Youve been working all day and youre hungry:', 'answer': 'Ill order a pizza',
					'filler': ['Ill cook something', "Ill have a coffee, Im a hipster"],
				},
			],
		},
		{
			'name': 'God Level Dev: 1010011110111111101011101100111001111001011100101110101111000011101000', 'type': 'code', 'cost': 30,
			'quiz': [
				{
					'question': 'How many processors are there in an 8 core processor?', 'answer': '1',
					'filler': ['8', '16 threads'],
				},
				{
					'question': '11010001101001111111', 'answer': '11010001101001',
					'filler': ['111100111001011110011', '11011101101111'],
				},
				{
					'question': 'What hardware platform is the Raspberry Pi built on?', 'answer': 'arm',
					'filler': ['amd', "x32"],
				},
			],
		},
	]: courses.append(Course.new(course))
