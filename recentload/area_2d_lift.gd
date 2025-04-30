extends Area2D

var player_in_range = false
@onready var task_scene = preload("res://scenes/task_box.tscn")  # Load the task box scene
var task_triggered = false
var cooldown = false  # Cooldown variable

func _on_body_entered_lift(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		print("Player entered interaction zone")

func _on_body_exited_lift(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		task_triggered = false  # Reset task state when player leaves
		print("Player exited interaction zone")

func _process(delta: float) -> void:
	if player_in_range and not task_triggered and not cooldown:
		if Input.is_action_just_pressed("ui_accept"):
			task_triggered = true
			print("Interaction key pressed")
			start_task()

func start_task() -> void:
	var task_box = task_scene.instantiate()
	get_tree().root.add_child(task_box)
	
	# Connect the task_ended signal to a function
	task_box.connect("task_ended", Callable(self, "_on_task_ended"))
	
	print("Task box instantiated")
	task_box.set_task_data("Task Information")  # Example function to set task details

# Function to handle the task_ended signal
#func _on_task_ended():
	#print("Task ended, resetting task_triggered")  # Debug statement
	#task_triggered = false  # Reset the task_triggered variable
	#cooldown = true  # Enable cooldown
	#await get_tree().create_timer(0.5).timeout  # Wait for 0.5 seconds
	#cooldown = false  # Disable cooldown
