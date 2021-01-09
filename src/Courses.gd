extends Node


var courses: Array = []


class Course:
	var name: String
	var type: String

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

		for quiz in course.quiz:
			quizzes.append(Quiz.new(quiz))
	
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
	]: courses.append(Course.new(course))
