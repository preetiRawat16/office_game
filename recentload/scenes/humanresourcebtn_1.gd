extends Button

@onready var wordpuzzel_scene  = preload("res://scenes/sql_test_game.tscn")

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/office.tscn")
