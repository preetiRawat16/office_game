extends Node

var current_test = null
var questions = []
var current_question_index = 0
var correct_answers = 0
var wrong_answers = 0

# Safe reference to the Finish button
@onready var exit_btn := get_node_or_null("FinishButton")
@onready var input_field := get_node_or_null("../Background/MarginContainer/Rows/InputArea/HBoxContainer/Input")
@onready var caret := get_node_or_null("../Background/MarginContainer/Rows/InputArea/HBoxContainer/Caret")
@onready var input_area := get_node_or_null("../Background/MarginContainer/Rows/InputArea")


func initialize(starting_test):
	current_test = starting_test
	questions = load_questions("res://use/samplequestions.json")
	current_question_index = 0
	correct_answers = 0
	wrong_answers = 0
	# Optionally hide exit button on restart
	if exit_btn:
		exit_btn.hide()

func load_questions(file_path: String) -> Array:
	if not FileAccess.file_exists(file_path):
		push_error("File not found: " + file_path)
		return []
	var file = FileAccess.open(file_path, FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()
	var json = JSON.new()
	var error = json.parse(json_text)
	if error != OK:
		push_error("Failed to parse JSON: " + json.get_error_message())
		return []
	var data = json.data
	if typeof(data) != TYPE_ARRAY:
		push_error("Invalid JSON format: Expected an array")
		return []
	return data

func process_command(input: String) -> String:
	input = input.strip_edges()
	if input == "":
		return "Please enter a command."

	if current_question_index >= questions.size():
		return "No more questions available."

	var current_question = questions[current_question_index]
	var correct_answer = current_question.get("answer", "")
	var question_text = current_question.get("question", "Missing question.")

	var normalized_input = input.to_lower()
	var normalized_answer = correct_answer.strip_edges().to_lower()

	var response_text := ""

	if normalized_input == normalized_answer:
		response_text = "✅ Correct!"
		correct_answers += 1
	else:
		response_text = "❌ Incorrect." 
		wrong_answers += 1

	current_question_index += 1

	if current_question_index < questions.size():
		response_text += "\n\nNext Question:\n" + questions[current_question_index]["question"]
	else:
		response_text += "\n\n🎉 You've completed all questions!\n"
		response_text += display_results()

		# Safely hide UI elements and show finish button
		if input_field: input_field.hide()
		if caret: caret.hide()
		if input_area: input_area.hide()
		if exit_btn:
			exit_btn.show()
			#exit_btn.pressed.connect(_on_exit_pressed, CONNECT_ONE_SHOT)

	return response_text

func display_results() -> String:
	var result = "\n --- Test Results ---\n"
	result += "  Correct Answers: %d\n" % correct_answers
	result += "  Wrong Answers: %d\n" % wrong_answers
	var total_questions = questions.size()
	result += "  Total Questions: %d\n" % total_questions
	var score = int(float(correct_answers) / total_questions * 100)
	result += "  Your Score: %d%%\n" % score
	
	Global.sqltask_result = score
	print(Global.sqltask_result)
	
	return result

func _on_exit_pressed():
	# Consider switching scenes or hiding the test interface instead
	get_parent().queue_free()  # Frees the whole game scene
	
