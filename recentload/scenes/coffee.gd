extends AnimatedSprite2D

@onready var audio_player = $coffeesound
@onready var interaction_area = $Area2D

var player_in_area = false
var action_queued = false

func _ready():
	stop()
	interaction_area.body_entered.connect(_on_area_body_entered)
	interaction_area.body_exited.connect(_on_area_body_exited)

func _on_area_body_entered(body):
	if body.name == "Player":  # Or use `body.is_in_group("player")` for flexibility
		player_in_area = true

func _on_area_body_exited(body):
	if body.name == "Player":
		player_in_area = false

func _input(event):
	if player_in_area and event.is_action_pressed("ui_accept") and not audio_player.playing:
		stop()
		audio_player.play()
		action_queued = true

func _on_coffeesound_finished():
	if action_queued:
		play()
		action_queued = false
