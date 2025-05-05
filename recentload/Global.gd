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
var hrtask_result = 0
var sqltask_result = 0
var emailtask_result = 0
var clickuptask_result = 0

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
