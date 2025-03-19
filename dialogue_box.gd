extends Control

signal dialogue_ended  # Signal for when dialogue ends

@onready var npc_name_label = $TextureRect/RichTextLabel
@onready var dialogue_label = $TextureRect/RichTextLabel2
@onready var character_image = $CharacterImage

var dialogue_data = {}
var current_npc = ""
var dialogue_index = 0
var current_scene = "scene1"  # Start with Scene 1

func _ready():
	load_dialogue_data()
	set_npc_dialogue("receptionist")  # Start with receptionist in Scene 1

func load_dialogue_data():
	var file = FileAccess.open("res://dialogues.json", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		dialogue_data = JSON.parse_string(content)
	else:
		print("Failed to load dialogue JSON")

func set_npc_dialogue(npc_name: String):
	if current_scene in dialogue_data and npc_name in dialogue_data[current_scene]:
		current_npc = npc_name
		dialogue_index = 0

		# Load the character image
		var image_path = "res://characters/character_img/" + npc_name + "_img.png"
		var image = load(image_path)
		if image:
			character_image.texture = image
		else:
			print("Character image not found:", image_path)

		update_dialogue()
	else:
		print("NPC not found in dialogue data:", npc_name)

func update_dialogue():
	if current_scene in dialogue_data and current_npc in dialogue_data[current_scene]:
		var npc_dialogues = dialogue_data[current_scene][current_npc]
		if dialogue_index < npc_dialogues.size():
			npc_name_label.text = current_npc.capitalize()
			dialogue_label.text = npc_dialogues[dialogue_index]
		else:
			print("End of dialogues for", current_npc)
			end_dialogue()  # Now exits if no more lines

func next_dialogue():
	if current_scene in dialogue_data and current_npc in dialogue_data[current_scene]:
		var npc_dialogues = dialogue_data[current_scene][current_npc]
		if dialogue_index < npc_dialogues.size() - 1:
			dialogue_index += 1
			update_dialogue()
		else:
			print("End of dialogue for", current_npc)
			end_dialogue()  # Ensures exit when dialogue is finished

func switch_to_scene_2():
	current_scene = "scene2"
	print("Switched to Scene 2")
	set_npc_dialogue("receptionist")  # Restart dialogue for Scene 2

func end_dialogue():
	emit_signal("dialogue_ended")  # Emit the signal
	queue_free()  # Remove the dialogue box from the scene

func _input(event):
	if event.is_action_pressed("ui_accept"):
		next_dialogue()
	elif event.is_action_pressed("ui_cancel"):  # Optional: Close on Escape key
		end_dialogue()
