extends Control

@onready var DisplayText = $AliceLabel
@onready var ListItem = $ItemList
@onready var SubmitButton = $AliceNextButton
@onready var FinishButton =$AliceSubmitButton2  # You’ll use signal for this
@onready var WrongPopup = $WrongAnsAlice # AcceptDialog for explanations

var quiz_data: Array = []
var current_question_index: int = 0
var player_answers: Array = []
var wrong_answer_feedbacks: Array = []
var next_after_popup: bool = false
var is_final_question: bool = false  # Flag for the final question

func _ready():
	load_quiz_data()
	if quiz_data.size() > 0:
		show_question()
	else:
		DisplayText.text = "Failed to load quiz data."
		SubmitButton.disabled = true

	SubmitButton.pressed.connect(_on_submit_pressed)
	WrongPopup.confirmed.connect(_on_wrong_popup_closed)
	FinishButton.pressed.connect(_on_finish_pressed)  # Connect the FinishButton press signal
	FinishButton.hide()  # Initially hide the FinishButton, shown only at the end

func load_quiz_data():
	var file_path = "res://AliceQuestions.json"
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
		is_final_question = is_last  # Set the flag for the last question
	else:
		DisplayText.text = "You've completed the task!"
		ListItem.clear()
		SubmitButton.hide()
		self.visible = false  # Hide the quiz background/UI

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
		# Store feedback
		var explanation = question["explanations"].get(str(selected_index), "No explanation available.")
		wrong_answer_feedbacks.append({
			"question": question["question"],
			"selected": question["options"][selected_index],
			"explanation": explanation
		})

		# Show popup with explanation before moving on
		WrongPopup.dialog_text = "Wrong answer!\n\nExplanation:\n" + explanation
		WrongPopup.popup_centered()
		next_after_popup = true  # Flag to continue after popup closes

func _on_wrong_popup_closed():
	if next_after_popup:
		next_after_popup = false

		# Check if we just answered the last question
		if is_final_question:
			# Hide or remove the quiz UI elements
			DisplayText.hide()
			ListItem.hide()
			SubmitButton.hide()
			FinishButton.hide()

			DisplayText.queue_free()
			ListItem.queue_free()
			SubmitButton.queue_free()
			FinishButton.queue_free()

			self.queue_free()
		else:
			current_question_index += 1
			show_question()


# Handle the FinishButton press for transitioning
func _on_finish_pressed():
	# Final question logic
	var question = quiz_data[current_question_index]
	var selected_index = ListItem.get_selected_items()[0]
	var correct = question["correctOptionIndex"]

	if selected_index != correct:
		# Show popup for the wrong answer before finishing
		var explanation = question["explanations"].get(str(selected_index), "No explanation available.")
		WrongPopup.dialog_text = "Wrong answer!\n\nExplanation:\n" + explanation
		WrongPopup.popup_centered()
		next_after_popup = true  # Flag to continue after popup closes

	else:
		# Hide or remove the quiz UI elements
		DisplayText.hide()
		ListItem.hide()
		SubmitButton.hide()
		FinishButton.hide()

		# Optionally, free the nodes if you want to completely remove them from memory
		DisplayText.queue_free()
		ListItem.queue_free()
		SubmitButton.queue_free()
		FinishButton.queue_free()
		# Scene change logic
		
		
		print("Scene changed to game1ends")
		self.queue_free() 	 # This will remove the current scene or UI from the tree
