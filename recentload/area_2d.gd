extends Area2D

var player_in_range = false
@onready var dialogue_scene = preload("res://scenes/dialogue_box.tscn")
var dialogue_triggered = false
var cooldown = false  # Add a cooldown variable

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		print("Player entered interaction zone")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		dialogue_triggered = false  # Reset dialogue state when player leaves the area
		print("Player exited interaction zone")

func _process(delta: float) -> void:
	if player_in_range and not dialogue_triggered and not cooldown:
		if Input.is_action_just_pressed("ui_accept"):
			dialogue_triggered = true
			print("Interaction key pressed")
			start_dialogue()

func start_dialogue() -> void:
	var dialogue = dialogue_scene.instantiate()
	get_tree().root.add_child(dialogue)
	
	# Connect the dialogue_ended signal to a function
	dialogue.connect("dialogue_ended", Callable(self, "_on_dialogue_ended"))
	
	print("Dialogue box instantiated")
	dialogue.set_npc_dialogue("receptionist")

# Function to handle the dialogue_ended signal
func _on_dialogue_ended():
	print("Dialogue ended, resetting dialogue_triggered")  # Debug statement
	dialogue_triggered = false  # Reset the dialogue_triggered variable
	cooldown = true  # Enable cooldown
	await get_tree().create_timer(0.5).timeout  # Wait for 0.5 seconds
	cooldown = false  # Disable cooldown
