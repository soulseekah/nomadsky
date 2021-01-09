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
		type = course['type']
		cost = course['cost']

		for quiz in course.quiz:
			quizzes.append(Quiz.new(quiz))
	
	func _to_string():
		return '[%s] %s $%d' % [type, name, cost]


func _ready():
	for course in [
		{
			'name': 'Beginner Level English', 'type': 'copywriting', 'cost': 7,
			'quiz': [
				{
					'question': 'What is the plural of cat?', 'answer': 'cats',
					'filler': ['cattes', 'chats'],
				},
				{
					'question': 'What is the plural of cat?', 'answer': 'cats',
					'filler': ['cattes', 'chats'],
				},
				{
					'question': 'What is the plural of cat?', 'answer': 'cats',
					'filler': ['cattes', 'chats'],
				},
			],
		},
		{
			'name': 'Intermediate Beginner Level English', 'type': 'copywriting', 'cost': 15,
			'quiz': [
				{
					'question': 'What is the plural of cat?', 'answer': 'cats',
					'filler': ['cattes', 'chats'],
				},
				{
					'question': 'What is the plural of cat?', 'answer': 'cats',
					'filler': ['cattes', 'chats'],
				},
				{
					'question': 'What is the plural of cat?', 'answer': 'cats',
					'filler': ['cattes', 'chats'],
				},
			],
		},
	]: courses.append(Course.new(course))
