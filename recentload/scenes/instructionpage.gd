extends Control
@onready var exit_btn = $goback

func _ready():
	exit_btn.pressed.connect(_on_exit_pressed)

func _on_exit_pressed():
	queue_free() 
