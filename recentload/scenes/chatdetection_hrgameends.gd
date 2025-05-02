extends Area2D

@export var npc_name: String = "HR"  # Set this in inspector for each NPC
var player_in_range = false
var dialogue_triggered = false
var cooldown = false

@onready var dialogue_scene = preload("res://scenes/dialogue_box.tscn")
var current_dialogue = null
var hr_docs_instance = null

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		print("Ready to talk to", npc_name)

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		print("Left conversation range")

func _process(delta):
	if (player_in_range 
		and not dialogue_triggered 
		and not cooldown 
		and Input.is_action_just_pressed("ui_accept")):
		
		dialogue_triggered = true
		start_dialogue()

func start_dialogue():
	current_dialogue = dialogue_scene.instantiate()
	get_tree().root.add_child(current_dialogue)
	current_dialogue.current_scene = Global.sceneChange  # Ensure correct scene is set
	current_dialogue.connect("dialogue_ended", _on_dialogue_ended)
	current_dialogue.set_npc_dialogue(npc_name) 	

func startgame():
	var hr_docs_scene = preload("res://scenes/HRTaskDocs.tscn")
	hr_docs_instance = hr_docs_scene.instantiate()
	get_tree().root.add_child(hr_docs_instance)
	hr_docs_instance.connect("quiz_finished", Callable(self, "_on_quiz_finished"))
	hr_docs_instance.current_scene = Global.sceneChange  # Optional if needed for quiz logic

func _on_quiz_finished():
	print("Quiz finished! Transitioning to next dialogue.")
	dialogue_triggered = false  # Allow re-triggering dialogue
	
	if player_in_range:
		start_dialogue()

func _on_dialogue_ended():
	var dialogue = dialogue_scene.instantiate()
	dialogue_triggered = false  # Allow new dialogue again
	cooldown = true
	await get_tree().create_timer(0.5).timeout
	cooldown = false

		
