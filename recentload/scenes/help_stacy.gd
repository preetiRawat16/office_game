extends Button
var current_task = null

@onready var wordpuzzel_scene  = preload("res://scenes/wordsearchpuzzel.tscn")
func _on_pressed():
	Global.meetStacy = true
	if Global.sceneChange == "clickupstarts":
		var puzzel_instance = wordpuzzel_scene.instantiate()
		get_tree().current_scene.add_child(puzzel_instance)
