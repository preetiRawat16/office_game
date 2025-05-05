extends Node2D

const GRID_SIZE = 10
const CELL_SIZE = 40
const WORDS = ["BETWEEN", "LIKE", "IN", "JOIN", "PRIMARY","FOREIGN"]
const ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
@onready var exit_btn = $leavepuzzel  # Make sure this matches your node's actual name/path


func _on_exit_pressed():
	queue_free()
@onready var grid = $GridContainer
var board_data = []
var cell_nodes = []
var is_dragging = false
var selected_positions := []
var selected_word := ""
@onready var question5 = $question5
@onready var answer5 = $answer5
@onready var question6 = $question6
@onready var answer6 = $answer6
@onready var answer1 = $answer1
@onready var answer2 = $answer2
@onready var answer3 = $answer3
@onready var answer4 = $answer4
@onready var btn = $leavepuzzel


func _ready():
	generate_grid()
	question5.visible = true
	answer5.visible = false
	question6.visible = true
	answer6.visible = false
	answer1.visible = false
	answer2.visible = false
	answer3.visible = false
	answer4.visible = false
	btn.visible = false
	exit_btn.pressed.connect(_on_exit_pressed)
	
	$q1.pressed.connect(_on_question_button_pressed.bind(1))
	$q2.pressed.connect(_on_question_button_pressed.bind(2))
	$q3.pressed.connect(_on_question_button_pressed.bind(3))
	$q4.pressed.connect(_on_question_button_pressed.bind(4))
	$q5.pressed.connect(_on_question_button_pressed.bind(5))
	$q6.pressed.connect(_on_question_button_pressed.bind(6))


func _on_question_button_pressed(question_number: int):
	
	var messages = {
		1: "SELECT * FROM orders WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31';",
		2: "SELECT * FROM customers WHERE name LIKE 'A%';",
		3: "SELECT * FROM products WHERE category IN ('Electronics', 'Books', 'Toys');",
		4: "SELECT orders.id, customers.name FROM orders JOIN customers ON orders.customer_id = customers.id;",
		5: "CREATE TABLE users (id INT PRIMARY KEY, name VARCHAR(100));",
		6: "CREATE TABLE orders (id INT PRIMARY KEY, customer_id INT, FOREIGN KEY (customer_id) REFERENCES customers(id));"
	
	}
	
	
	$hint.dialog_text = messages.get(question_number, "No help available for this question.")
	
	$hint.title = "HINT: The word is in this query"
	
	$hint.popup_centered()
func update_button_visibility() -> void:
	btn.visible = Global.a1 and Global.a2 and Global.a3 and Global.a4 and Global.a5 and Global.a6
func generate_grid():
	grid.columns = GRID_SIZE
	cell_nodes.clear()
	board_data.clear()

	# Clear previous
	for child in grid.get_children():
		child.queue_free()

	# Initialize the grid with empty letters
	for y in range(GRID_SIZE):
		var row_letters = []
		var row_nodes = []
		for x in range(GRID_SIZE):
			var letter = " "  # Initialize with empty space
			row_letters.append(letter)

			var label = Label.new()
			label.text = letter
			label.custom_minimum_size = Vector2(CELL_SIZE, CELL_SIZE)
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			label.name = "%d_%d" % [x, y]
			label.add_theme_color_override("font_color", Color.BLACK)
			grid.add_child(label)
			row_nodes.append(label)
		board_data.append(row_letters)
		cell_nodes.append(row_nodes)

	# Place words on the grid
	place_words()

	# Fill the remaining empty cells with random letters
	fill_random_letters()

func place_words():
	for word in WORDS:
		var placed = false
		var attempts = 0
		while not placed and attempts < 100:
			attempts += 1
			var direction = randi() % 2  # 0 = horizontal, 1 = vertical

			# Choose start positions such that the word fits and is not on the last column
			var max_x = GRID_SIZE - (word.length() if direction == 0 else 1)
			var max_y = GRID_SIZE - (word.length() if direction == 1 else 1)

			# Ensure words don't start in or extend into the last column
			max_x = min(max_x, GRID_SIZE - 2)  # -2 because -1 would be last column

			var start_x = randi() % (max_x + 1)
			var start_y = randi() % (max_y + 1)

			# Additional check to prevent words from extending into last column
			if direction == 0 and (start_x + word.length() - 1) >= GRID_SIZE - 1:
				continue

			var can_place = true
			for i in range(word.length()):
				var x = start_x + (i if direction == 0 else 0)
				var y = start_y + (i if direction == 1 else 0)
				
				# Double check we're not in the last column
				if x >= GRID_SIZE - 1:
					can_place = false
					break
					
				if board_data[y][x] != " ":
					can_place = false
					break

			if can_place:
				for i in range(word.length()):
					var x = start_x + (i if direction == 0 else 0)
					var y = start_y + (i if direction == 1 else 0)
					board_data[y][x] = word[i]
					cell_nodes[y][x].text = word[i]
				placed = true

		if not placed:
			push_warning("Could not place word: %s after 100 attempts" % word)

func fill_random_letters():
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			if board_data[y][x] == " ":
				var letter = ALPHABET[randi() % ALPHABET.length()]
				board_data[y][x] = letter
				cell_nodes[y][x].text = letter

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_dragging = true
				selected_positions.clear()
				selected_word = ""
			else:
				is_dragging = false
				check_selected_word()

	elif event is InputEventMouseMotion and is_dragging:
		var global_pos = event.position
		var local_pos = grid.get_local_mouse_position()
		var cell_x = int(floor(local_pos.x / CELL_SIZE))
		var cell_y = int(floor(local_pos.y / CELL_SIZE))

		# Make sure the selection is within bounds
		if cell_x >= 0 and cell_x < GRID_SIZE and cell_y >= 0 and cell_y < GRID_SIZE:
			var pos = Vector2i(cell_x, cell_y)
			if not selected_positions.has(pos):
				selected_positions.append(pos)
				var label = cell_nodes[pos.y][pos.x]
				label.add_theme_color_override("font_color", Color.RED)
				selected_word += board_data[pos.y][pos.x]

func check_selected_word():
	# Ensure the selected positions form a valid word
	if selected_word in WORDS:
		print("✅ Found word:", selected_word)
		if selected_word == "PRIMARY":
			answer5.visible = true
			Global.a5 = true
			update_button_visibility()
		elif selected_word == "FOREIGN":
			answer6.visible = true
			Global.a6 = true
			update_button_visibility()
		elif selected_word == "BETWEEN":
			answer1.visible = true
			Global.a1 = true
			update_button_visibility()
		elif selected_word == "LIKE":
			answer2.visible = true
			Global.a2 = true
			update_button_visibility()
		elif selected_word == "IN":
			answer3.visible = true
			Global.a3 = true
			update_button_visibility()
		elif selected_word == "JOIN":
			answer4.visible = true
			Global.a4 = true
			update_button_visibility()
	else:
		print("❌ Not a valid word:", selected_word)

	# Reset the word highlight
	reset_selected()

func reset_selected():
	# Reset color and clear selection
	for pos in selected_positions:
		var label = cell_nodes[pos.y][pos.x]
		label.add_theme_color_override("font_color", Color.BLACK)
	selected_positions.clear()
	selected_word = ""


func _on_leavepuzzel_pressed() -> void:
	pass # Replace with function body.
