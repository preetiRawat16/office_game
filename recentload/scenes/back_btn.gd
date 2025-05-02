extends Button


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/office_desk.tscn")
	if Global.sceneChange != "finalscene":
		Global.sceneChange = "clickupstarts" # Replace with function body.
