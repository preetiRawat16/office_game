extends Node2D

@onready var camera = $Camera2D  # Reference the Camera2D node

var moving_down = false  # Prevent multiple triggers

func _ready():
	camera.make_current()  # Ensure Camera2D is active

func _input(event):
	# Check if the event is a key press and the key is pressed
	if event is InputEventKey and event.pressed and not moving_down:
		moving_down = true
		move_camera_down()
	
	# Check if the event is a mouse button press (left mouse button)
	if event is InputEventMouseButton and event.pressed and not moving_down:
		moving_down = true
		move_camera_down()

func move_camera_down():
	var tween = create_tween()
	var move_distance = -700  # Adjust this based on your scene layout

	tween.tween_property(camera, "position", camera.position + Vector2(0, move_distance), 2.0)
	await tween.finished
