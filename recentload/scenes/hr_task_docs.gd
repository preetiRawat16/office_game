extends Control

@onready var DisplayText = $Label
@onready var ListItem = $ItemList
@onready var SubmitButton = $Button
@onready var FinishButton = $Button2
@onready var ResultButton = $ResultLabel
@onready var EndTaskButton = $Button3

var quiz_data: Array = []
var current_question_index: int = 0
var player_answers: Array = []
var wrong_answer_feedbacks: Array = []
var correct_answers = 0
var wrong_answers = 0

func _ready():
	ResultButton.visible = false
	EndTaskButton.visible = false
	load_quiz_data()

	if quiz_data.size() > 0:
		show_question()
	else:
		DisplayText.text = "Failed to load quiz data."
		SubmitButton.disabled = true
		FinishButton.disabled = true

	SubmitButton.pressed.connect(_on_submit_pressed)
	FinishButton.pressed.connect(_on_finish_pressed)
	EndTaskButton.pressed.connect(_on_endbutton_pressed)
	FinishButton.hide()

func load_quiz_data():
	var file_path = "res://use/HRTaskGame.json"
	if not FileAccess.file_exists(file_path):
		print("JSON file not found at:", file_path)
		return

	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		print("Failed to open the file.")
		return

	var content = file.get_as_text()
	var parsed = JSON.parse_string(content)

	if typeof(parsed) == TYPE_ARRAY:
		quiz_data = parsed
	elif typeof(parsed) == TYPE_DICTIONARY and parsed.has("result"):
		quiz_data = parsed["result"]
	else:
		print("Unexpected JSON structure.")

func show_question():
	if current_question_index < quiz_data.size():
		var question_data = quiz_data[current_question_index]
		DisplayText.text = question_data["question"]

		ListItem.clear()
		for option in question_data["options"]:
			ListItem.add_item(option)

		DisplayText.visible = true
		ListItem.visible = true
		ResultButton.visible = false

		var is_last = current_question_index == quiz_data.size() - 1
		SubmitButton.visible = !is_last
		FinishButton.visible = is_last
	else:
		DisplayText.text = "You've completed the task!"
		ListItem.clear()

func _on_submit_pressed():
	if ListItem.get_selected_items().size() == 0:
		return

	var selected_index = ListItem.get_selected_items()[0]
	player_answers.append(selected_index)

	var question = quiz_data[current_question_index]
	var correct = question["correctOptionIndex"]

	if selected_index == correct:
		DisplayText.text = "Correct! ✅"
		correct_answers += 1
	else:
		DisplayText.text = "Wrong. ❌"
		wrong_answers += 1

	await get_tree().create_timer(1.2).timeout
	current_question_index += 1
	show_question()

func _on_finish_pressed():
	if ListItem.get_selected_items().size() == 0:
		return

	# Prevent double-append of the last answer
	if player_answers.size() < quiz_data.size():
		var selected_index = ListItem.get_selected_items()[0]
		player_answers.append(selected_index)

		var last_question = quiz_data[current_question_index]
		var correct = last_question["correctOptionIndex"]

		if selected_index == correct:
			correct_answers += 1
		else:
			wrong_answers += 1

	# Clear old feedback
	wrong_answer_feedbacks.clear()

	for i in range(quiz_data.size()):
		var question = quiz_data[i]
		var selected = player_answers[i]
		var correct = question["correctOptionIndex"]

		if selected != correct:
			var explanation = question["explanations"].get(str(selected), "No explanation available.")
			wrong_answer_feedbacks.append({
				"question": question["question"],
				"selected": question["options"][selected],
				"explanation": explanation
			})

	# Hide UI and show result
	DisplayText.visible = false
	ListItem.visible = false
	SubmitButton.hide()
	FinishButton.hide()
	ResultButton.visible = true

	display_results()

func display_results():
	EndTaskButton.visible = true
	var total_questions = quiz_data.size()
	var score = int(float(correct_answers) / total_questions * 100)

	var result_text = ""
	result_text += "\n--- Test Results ---\n"
	result_text += "Correct Answers: %d\n" % correct_answers
	result_text += "Wrong Answers: %d\n" % wrong_answers
	result_text += "Total Questions: %d\n" % total_questions
	result_text += "Your Score: %d%%\n\n" % score


	ResultButton.text = result_text
	Global.sceneChange = "game1ends"

func _on_endbutton_pressed() -> void:
	queue_free()
