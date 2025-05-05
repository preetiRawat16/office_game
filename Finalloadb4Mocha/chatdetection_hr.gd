extends Area2D

@export var npc_name: String = "HR"
var player_in_range = false
var dialogue_triggered = false
var cooldown = false
var current_task = null

@onready var dialogue_scene = preload("res://scenes/dialogue_box.tscn")
@onready var game = preload("res://scenes/HRTaskDocs.tscn")

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
	dialogue.current_scene = Global.sceneChange
	dialogue.connect("dialogue_ended", _on_dialogue_ended)
	dialogue.set_npc_dialogue(npc_name)

func _on_dialogue_ended():
	cooldown = true
	await get_tree().create_timer(0.5).timeout
	dialogue_triggered = false
	cooldown = false

	if Global.sceneChange == "act1scene1":
		player_in_range = false
		current_task = game.instantiate()
		get_tree().root.add_child(current_task)
		current_task.connect("task_ended", Callable(self, "_on_task_ended"))

func _on_task_ended():
	if current_task:
		current_task.queue_free()
		current_task = null
	
	Global.sceneChange = "game1ends"
	player_in_range = true
	# Prevent re-triggering first message
	dialogue_triggered = true
	
	await get_tree().create_timer(0.3).timeout  # brief delay before next dialogue
	start_dialogue()
