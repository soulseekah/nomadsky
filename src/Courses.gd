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
					'filler': ['comma', 'colon'],
				},
				{
					'question': 'How many mistakes can you make in a text (write a number)?', 'answer': '0',
					'filler': ['cattes', 'chats'],
				},
			],
		},
		{
			'name': 'Intermediate Level English: Greetings', 'type': 'copywriting', 'cost': 15,
			'quiz': [
				{
					'question': 'What html tag is used to wrap the first title in the text?', 'answer': 'h1',
					'filler': ['cattes', 'chats'],
				},
				{
					'question': 'In what case should you write the first character in a sentence?', 'answer': 'uppercase',
					'filler': ['cattes', 'chats'],
				},
				{
					'question': 'What should be added after each word in the text?', 'answer': 'keyword',
					'filler': ['cattes', 'chats'],
				},
			],
		},
		{
			'name': 'God Level English: ‘Ello, gov’nor!', 'type': 'copywriting', 'cost': 30,
			'quiz': [
				{
					'question': 'How often should the keyword appear in the text?', 'answer': 'constantly',
					'filler': ['cattes', 'chats'],
				},
				{
					'question': 'Is it worth buying 10,000 links to your post?', 'answer': 'yes',
					'filler': ['cattes', 'chats'],
				},
				{
					'question': 'What is the name of the Google tool for webmasters?', 'answer': 'search console',
					'filler': ['cattes', 'chats'],
				},
			],
		},
		{
			'name': 'Beginner Gamedev: ____', 'type': 'gamedev', 'cost': 7,
			'quiz': [
				{
					'question': 'What's the name of Mario's brother?', 'answer': 'Luigi',
					'filler': ['cattes', 'chats'],
				},
				{
					'question': 'What is the best game of all?', 'answer': 'this game',
					'filler': ['cattes', 'chats'],
				},
				{
					'question': 'In the production of which game was Keanu Reeves actively involved?', 'answer': 'cyberpunk 2077',
					'filler': ['cattes', 'chats'],
				},
			],
		},
		{
			'name': 'Intermediate Gamedev: Hello Games', 'type': 'gamedev', 'cost': 15,
			'quiz': [
				{
					'question': 'What's the name of the lady who's always raiding tombs?', 'answer': 'Lara Croft',
					'filler': ['cattes', 'chats'],
				},
				{
					'question': 'If you were developing a game now, what would be the deadline?', 'answer': 'january 29',
					'filler': ['cattes', 'chats'],
				},
				{
					'question': 'What should you do if you are being chased by a zombie?', 'answer': 'to kill him',
					'filler': ['cattes', 'chats'],
				},
			],
		},
		{
			'name': 'God Level Gamedev: Gaben', 'type': 'gamedev', 'cost': 30,
			'quiz': [
				{
					'question': 'At what stage in the development of a game in early access should you finish working on it?', 'answer': 'early access',
					'filler': ['cattes', 'chats'],
				},
				{
					'question': 'Who gets fresh meat with a hook?', 'answer': 'Pudge',
					'filler': ['Hoodwink', 'Io'],
				},
				{
					'question': 'What happens if you defuse a bomb?', 'answer': 'counter terrorist win',
					'filler': ['cattes', 'chats'],
				},
			],
		},
	]: courses.append(Course.new(course))
