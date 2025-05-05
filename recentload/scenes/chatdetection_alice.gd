extends Area2D

@export var npc_name: String = "Alice"  # Set this in inspector for each NPC
var player_in_range = false
var dialogue_triggered = false
var cooldown = false
var current_task = null
@onready var dialogue_scene = preload("res://scenes/dialogue_box.tscn")
@onready var asking = preload("res://scenes/AskAlice.tscn")
@onready var game = preload("res://scenes/control.tscn")
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
	dialogue.current_scene = Global.sceneChange  # Ensure correct scene is set
	dialogue.connect("dialogue_ended", _on_dialogue_ended)
	dialogue.set_npc_dialogue(npc_name)  # Use the exported npc_name

func _on_dialogue_ended():
	cooldown = true
	await get_tree().create_timer(0.5).timeout
	dialogue_triggered = false
	cooldown = false

	if Global.sceneChange == "clickupstarts":
		Global.meetAlice = true
		player_in_range = false  # 👈 This is important
		$CollisionShape2D.disabled = true  # 👈 Disable interaction zone temporarily

		var emailtest = game.instantiate()
		#emailtest.connect("email_test_game_finished", Callable(self, "_on_task_ended"))
		get_tree().current_scene.add_child(emailtest)


func _on_task_ended():
	print("Test finished. Returning to main game.")
	dialogue_triggered = false
	cooldown = false
	player_in_range = true
	$CollisionShape2D.disabled = false
