var courses: Array = []

class Course:
	var name: String
	var type: String

	var cost: int
	var bonus: float


# Courses
func _ready():
	for course_data in [
		[ 'Beginner Level English', 'copywriting', 100, 10, [
			''
		] ]
	]:
		var course: Course = Course.new()
		[course.name, course.type, course.cost, course.bonus] = course_data

		courses.append(course)
	
	print(courses)
