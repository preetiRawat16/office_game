extends Control

const Response = preload("res://response.tscn")
const InputResponse = preload("res://scenes/input_response.tscn")
const InputHistory = preload("res://scenes/input_response.tscn")  # This line seems redundant – same as above


var max_scroll_length := 0

@onready var history_rows = $Background/MarginContainer/Rows/GameInfo/Scroll/HistoryRows
@onready var scroll = $Background/MarginContainer/Rows/GameInfo/Scroll
@onready var command_processor = $CommandProcessor
@onready var scrollbar = scroll.get_v_scroll_bar()

# Removed @onready from here — we will safely get it in _ready()
var exit_btn

func _ready() -> void:
	# Safely attempt to get FinishButton
	exit_btn = get_node_or_null("$CommandProcessor/FinishButton")
	if exit_btn:
		exit_btn.hide()
	else:
		print("⚠ FinishButton not found in scene!")

	# Set up command processor
	command_processor.initialize("sql_test")  # can be any identifier

	# Start the game with welcome message and first question
	var starting_message = Response.instantiate()
	var first_question = command_processor.questions[0]["question"]
	starting_message.text = "  Welcome to the SQL Test Game!\nAnswer the following questions:\n\n" + first_question
	add_response_to_game(starting_message)

	# Connect scroll handling
	scrollbar.changed.connect(handle_scrollbar_changed)

func handle_scrollbar_changed():
	if max_scroll_length != scrollbar.max_value:
		max_scroll_length = scrollbar.max_value
	scroll.scroll_vertical = max_scroll_length

func _on_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return

	var input_response = InputResponse.instantiate()
	var response = command_processor.process_command(new_text)
	input_response.set_text(response, new_text)
	add_response_to_game(input_response)

func add_response_to_game(response: Control):
	history_rows.add_child(response)
