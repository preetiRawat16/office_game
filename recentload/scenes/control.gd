extends Control

var questions = []
var current_index = 0
var player_answers: Array = []
var correct_answers = 0
var wrong_answers = 0



@onready var question_label = $QuestionLabel
@onready var option_buttons = [
	$PanelContainer/MarginContainer/VBoxContainer/OptionContent/HBoxContainer/Button,
	$PanelContainer/MarginContainer/VBoxContainer/OptionContent/HBoxContainer/Button2,
	$PanelContainer/MarginContainer/VBoxContainer/OptionContent/HBoxContainer/Button3,
	$PanelContainer/MarginContainer/VBoxContainer/OptionContent/HBoxContainer/Button4
]
@onready var email_body = $PanelContainer/MarginContainer/VBoxContainer/EmailContent/Scroll/VBoxContainer/EmailBody

func _ready():
	load_questions()
	# Connect once globally
	for i in range(option_buttons.size()):
		option_buttons[i].connect("pressed", Callable(self, "_on_button_pressed").bind(i))
	show_question()

func load_questions():
	var file = FileAccess.open("res://use/emailquestions.json", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var parsed = JSON.parse_string(content)
		if typeof(parsed) == TYPE_ARRAY:
			questions = parsed
		else:
			push_error("Unexpected JSON format.")
	else:
		push_error("Could not load questions!")

func show_question():
	if current_index >= questions.size():
		# Display the completion message with the results
		question_label.text = "You've completed the email!"
		display_results()  # Call a function to display the results
		for btn in option_buttons:
			btn.visible = false
		return

	var q = questions[current_index]
	question_label.text = q["question"]

	for i in range(option_buttons.size()):
		var btn = option_buttons[i]
		btn.text = q["options"][i]
		btn.disabled = false
		btn.visible = true

func _on_button_pressed(index):
	var question = questions[current_index]
	var correct_index = question["correctOptionIndex"]
	var selected_text = question["options"][index]

	# Disable all buttons
	for btn in option_buttons:
		btn.disabled = true
	
	# Change color of selected button
	var selected_button = option_buttons[index]
	if index == correct_index:
		selected_button.modulate = Color(0, 1, 0)  # Green for correct answer
		correct_answers += 1  # Increment correct answers count
	else:
		selected_button.modulate = Color(1, 0, 0)  # Red for wrong answer
		wrong_answers += 1  # Increment wrong answers count
	
	# Append selected answer to email body
	email_body.text += "  " + selected_text + "\n"
	player_answers.append(index)

	# Wait a bit to show the color change and then proceed
	await get_tree().create_timer(1.0).timeout
	# Reset button color and move to next question
	selected_button.modulate = Color(1, 1, 1)  # Reset to default color
	current_index += 1
	show_question()

# Function to display the results at the end of the test
func display_results():
	email_body.text = ""
	email_body.text += "\n --- Test Results ---\n"
	email_body.text += "  Correct Answers: %d\n" % correct_answers
	email_body.text += "  Wrong Answers: %d\n" % wrong_answers
	var total_questions = questions.size()
	email_body.text += "  Total Questions: %d\n" % total_questions
	var score = int(float(correct_answers) / total_questions * 100)
	email_body.text += "  Your Score: %d%%\n" % score
