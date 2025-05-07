extends Area2D

@onready var audio_player = $AudioPlayer
@onready var heart = $heart
@onready var heart2 = $heart2

var player_inside = false
var show_heart2_timer = Timer.new()
var hide_both_timer = Timer.new()

func _ready():
	audio_player.stream = load("res://sound/mocha.ogg")
	audio_player.volume_db = 4

	# Make both hearts invisible at start
	heart.visible = false
	heart2.visible = false

	# Setup show_heart2_timer (1 second delay)
	show_heart2_timer.wait_time = 0.5
	show_heart2_timer.one_shot = true
	show_heart2_timer.connect("timeout", _on_show_heart2_timeout)
	add_child(show_heart2_timer)

	# Setup hide_both_timer (2 seconds delay)
	hide_both_timer.wait_time = 1.5
	hide_both_timer.one_shot = true
	hide_both_timer.connect("timeout", _on_hide_both_timeout)
	add_child(hide_both_timer)

func _on_body_entered(body):
	if body.name == "Player":
		player_inside = true
		audio_player.play()

func _on_body_exited(body):
	if body.name == "Player":
		player_inside = false

func _input(event):
	if player_inside and event.is_action_pressed("ui_accept"):
		audio_player.play()
		show_heart_sequence()

func show_heart_sequence():
	# Show heart immediately
	heart.visible = true
	heart.play("default")  # If AnimatedSprite2D, otherwise remove .play()
	
	# Start timers
	show_heart2_timer.start()
	hide_both_timer.start()

func _on_show_heart2_timeout():
	heart2.visible = true
	heart2.play("default")  # If AnimatedSprite2D, otherwise remove .play()

func _on_hide_both_timeout():
	heart.visible = false
	heart2.visible = false
