extends Area2D

@export var dialogue_message: String = "Hello World"

var player_in_range: bool = false

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		# Access the CanvasLayer using the correct path
		var dialogue_ui = get_node("../../CanvasLayer")
		dialogue_ui.show_dialogue(dialogue_message)

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
