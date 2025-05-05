extends Control

@onready var DisplayText = $Label
@onready var ListItem = $ItemList
@onready var SubmitButton = $Button
@onready var FinishButton = $Button2
@onready var WrongPopup = $WrongPopup

signal task_ended

var quiz_data: Array = []
var current_question_index: int = 0
var player_answers: Array = []
var wrong_answer_feedbacks: Array = []
var next_after_popup: bool = false
var is_final_question: bool = false

func _ready():
	load_quiz_data()
	if quiz_data.size() > 0:
		show_question()
	else:
		DisplayText.text = "Failed to load quiz data."
		SubmitButton.disabled = true

	SubmitButton.pressed.connect(_on_submit_pressed)
	WrongPopup.confirmed.connect(_on_wrong_popup_closed)
	FinishButton.pressed.connect(_on_finish_pressed)
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

		var is_last = current_question_index == quiz_data.size() - 1
		SubmitButton.visible = !is_last
		FinishButton.visible = is_last
		is_final_question = is_last
	else:
		DisplayText.text = "You've completed the task!"
		ListItem.clear()
		SubmitButton.hide()
		self.visible = false

func _on_submit_pressed():
	if ListItem.get_selected_items().size() == 0:
		return

	var selected_index = ListItem.get_selected_items()[0]
	player_answers.append(selected_index)

	var question = quiz_data[current_question_index]
	var correct = question["correctOptionIndex"]

	if selected_index == correct:
		DisplayText.text = "Correct! ✅"
		await get_tree().create_timer(1.2).timeout
		current_question_index += 1
		show_question()
	else:
		var explanation = question["explanations"].get(str(selected_index), "No explanation available.")
		wrong_answer_feedbacks.append({
			"question": question["question"],
			"selected": question["options"][selected_index],
			"explanation": explanation
		})

		WrongPopup.dialog_text = "Wrong answer!\n\nExplanation:\n" + explanation
		WrongPopup.popup_centered()
		next_after_popup = true

func _on_wrong_popup_closed():
	if next_after_popup:
		next_after_popup = false

		if is_final_question:
			# 🔥 Emit signal before destroying
			emit_signal("task_ended")
			Global.sceneChange = "game1ends"
			print("Scene changed to game1ends")

			queue_free()
		else:
			current_question_index += 1
			show_question()

func _on_finish_pressed():
	var question = quiz_data[current_question_index]
	var selected_index = ListItem.get_selected_items()[0]
	var correct = question["correctOptionIndex"]

	if selected_index != correct:
		var explanation = question["explanations"].get(str(selected_index), "No explanation available.")
		WrongPopup.dialog_text = "Wrong answer!\n\nExplanation:\n" + explanation
		WrongPopup.popup_centered()
		next_after_popup = true
	else:
		# 🔥 Emit signal before destroying
		emit_signal("task_ended")
		Global.sceneChange = "game1ends"
		print("Scene changed to game1ends")

		queue_free()
