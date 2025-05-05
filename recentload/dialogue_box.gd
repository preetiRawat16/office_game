extends Control

signal dialogue_ended  # Signal for when dialogue ends
@onready var blip_player = $BlipPlayer
var full_text = ""
var displayed_text = ""
var char_index = 0
var typing = false
var text_speed = 0.025  # Adjust as needed

@onready var npc_name_label = $TextureRect/RichTextLabel
@onready var dialogue_label = $TextureRect/RichTextLabel2
@onready var character_image = $CharacterImage

var dialogue_data = {}
var current_npc = ""
var dialogue_index = 0
var current_scene = "act1scene1"  # Start with Scene 1

func _ready():
	load_dialogue_data()

func load_dialogue_data():
	var file = FileAccess.open("res://dialogues.json", FileAccess.READ)
	if file:
		dialogue_data = JSON.parse_string(file.get_as_text())
	else:
		push_error("Failed to load dialogue JSON")

func set_npc_dialogue(npc_name: String, update_now: bool = true):
	if current_scene in dialogue_data and npc_name in dialogue_data[current_scene]:
		current_npc = npc_name
		dialogue_index = 0
		
		# Load character image
		var image = load("res://characters/character_img/%s_img.png" % npc_name)
		if image:
			character_image.texture = image
		
		if update_now:
			update_dialogue()

func update_dialogue():
	var npc_dialogues = dialogue_data[current_scene][current_npc]
	if dialogue_index < npc_dialogues.size():
		if current_npc == "HR":
			npc_name_label.text = "HR"
		else:
			npc_name_label.text = current_npc.capitalize()
		
		full_text = npc_dialogues[dialogue_index]
		displayed_text = ""
		char_index = 0
		dialogue_label.text = ""
		typing = true
		start_typing()
	else:
		end_dialogue()
		
func next_dialogue():
	if current_scene in dialogue_data and current_npc in dialogue_data[current_scene]:
		var npc_dialogues = dialogue_data[current_scene][current_npc]
		if dialogue_index < npc_dialogues.size() - 1:
			dialogue_index += 1
			update_dialogue()
		else:
			print("End of dialogue for", current_npc)
			end_dialogue()  # Ensures exit when dialogue is finished

  # Restart dialogue for Scene 2
func setscene(scene_name:String):
	current_scene = scene_name
	print("Scene set to:", current_scene)

func start_typing():
	if char_index < full_text.length():
		var current_char = full_text[char_index]
		displayed_text += current_char
		dialogue_label.text = displayed_text
		char_index += 1
		
		# Check if the current character is punctuation or space
		if current_char not in [".", ",", "!", "?", ";", ":", "-", "(", ")", "\"", "'"]:
			# Play blip sound for non-punctuation and non-space characters
			blip_player.pitch_scale = randf_range(0.95, 1.05)
			blip_player.play()
		
		# Adjust the text_speed for longer pauses for punctuation and spaces
		var delay_time = text_speed
		if current_char == " " or current_char in [".", ",", "!", "?", ";", ":", "-", "(", ")", "\"", "'"]:
			delay_time = text_speed * 2  # Increase the delay after punctuation and spaces for longer pauses

		await get_tree().create_timer(delay_time).timeout
		start_typing()  # Continue typing the next character
	else:
		typing = false  # Stop typing when all characters have been displayed

func end_dialogue():
	emit_signal("dialogue_ended")  # Emit the signal
	queue_free()  # Remove the dialogue box from the scene

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if typing:
			# Instantly finish current line
			char_index = full_text.length()
			dialogue_label.text = full_text
			typing = false
		else:
			next_dialogue()
	elif event.is_action_pressed("ui_cancel"):
		end_dialogue()
