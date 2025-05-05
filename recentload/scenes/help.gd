extends Button
@onready var wordpuzzel_scene  = preload("res://scenes/instructionpage.tscn")
func _on_pressed():
		var puzzel_instance = wordpuzzel_scene.instantiate()
		get_tree().current_scene.add_child(puzzel_instance)
