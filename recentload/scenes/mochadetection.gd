extends Area2D

@onready var audio_player = $AudioPlayer
var player_inside = false

func _ready():
	audio_player.stream = load("res://sound/mocha.ogg")


func _on_body_entered(body):
	if body.name == "Player":  # Adjust if your player has a different name
		player_inside = true
		audio_player.play()

func _on_body_exited(body):
	if body.name == "Player":
		player_inside = false

func _input(event):
	if player_inside and event.is_action_pressed("ui_accept"):
		audio_player.play()
