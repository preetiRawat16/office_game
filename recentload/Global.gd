extends Node

var sceneChange = "act1scene1"
var meetStacy = false
var meetAlice = false
var hrcheck = false
var itcheck = false
var alicecheck = false
var stacycheck = false
var a1 = false
var a2 = false
var a3 = false
var a4 = false
var a5 = false
var a6 = false

var bgm_player: AudioStreamPlayer

func _ready():
	if not bgm_player:
		bgm_player = AudioStreamPlayer.new()
		
		# Load the audio stream
		var stream = load("res://sound/bg_music.ogg") as AudioStream
		stream.loop = true  # Set the loop property on the AudioStream
		
		bgm_player.stream = stream
		bgm_player.volume_db = -15
		add_child(bgm_player)
		bgm_player.play()  # Start playback manually

var escape_button_scene := preload("res://scenes/escbtn.tscn")
var escape_button_instance = null

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # Default for Escape key
		toggle_escape_menu()

func toggle_escape_menu():
	if escape_button_instance and escape_button_instance.is_inside_tree():
		# Already exists → remove it
		escape_button_instance.queue_free()
		escape_button_instance = null
	else:
		# Create and show
		escape_button_instance = escape_button_scene.instantiate()
		get_tree().current_scene.add_child(escape_button_instance)
		
func close_escape_menu(menu_instance):
	if escape_button_instance == menu_instance:
		escape_button_instance.queue_free()
		escape_button_instance = null
