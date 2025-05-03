extends Area2D

@export var npc_name: String = "Stacy"  # Set this in inspector for each NPC
var player_in_range = false
var dialogue_triggered = false
var cooldown = false
var current_task = null
@onready var dialogue_scene = preload("res://scenes/dialogue_box.tscn")
@onready var asking = preload("res://scenes/AskStacy.tscn")
@onready var wordpuzzel_scene  = preload("res://scenes/wordsearchpuzzel.tscn")
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
	var dialogue = dialogue_scene.instantiate()
	get_tree().root.add_child(dialogue)
	print(dialogue.current_scene)
	dialogue.current_scene = Global.sceneChange  # Ensure correct scene is set
	dialogue.connect("dialogue_ended", _on_dialogue_ended)
	dialogue.set_npc_dialogue(npc_name)  # Use the exported npc_name

	

func _on_dialogue_ended():
	cooldown = true
	await get_tree().create_timer(0.5).timeout
	dialogue_triggered = false
	cooldown = false
	if Global.sceneChange == "clickupstarts":
		Global.meetStacy = true
		var puzzel_instance = wordpuzzel_scene.instantiate()
		get_tree().current_scene.add_child(puzzel_instance)
		
func _on_task_ended():
	if current_task:
		current_task.queue_free()
		current_task = null
