# GM.gd
extends Node

var current_scene = "act1scene1"  # Default starting scene

func set_scene(scene_name: String):
	current_scene = scene_name
	print("[GM] Scene changed to: ", current_scene)
