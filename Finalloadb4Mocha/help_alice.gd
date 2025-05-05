extends Button
var current_task = null

@onready var game = preload("res://scenes/AliceTask.tscn")
func _on_pressed():
	Global.meetAlice = true
	if Global.sceneChange == "clickupstarts":
		var task_box = game.instantiate()
		get_tree().root.add_child(task_box)
		task_box.connect("task_ended", Callable(self, "_on_task_ended"))
func _on_task_ended():
	if current_task:
		current_task.queue_free()
		current_task = null
