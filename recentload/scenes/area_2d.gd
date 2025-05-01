extends Area2D

var player_in_range = false
@onready var task_scene = preload("res://scenes/officelift.tscn")  # Load the reception lift
var task_triggered = false
var cooldown = false  # Cooldown variable
@onready var dialogue_scene = preload("res://scenes/dialogue_box.tscn")
var dialogue_triggered = false
var current_task = null
var current_dialogue = null
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		print("Player entered interaction zone")

func _on_body_exited(body: Node2D) -> void:
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
	Global.sceneChange = "act3scene1"
	
	
	print("Task box instantiated")
 # Example function to set task details


func _on_task_ended():
	if current_task:
		current_task.queue_free()
		current_task = null
