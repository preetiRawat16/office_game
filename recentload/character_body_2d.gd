extends CharacterBody2D

# Speed in pixels/sec. making a change
var speed = 200

# Variable to keep track of the last movement direction
var last_direction = Vector2.ZERO

@onready var animation_sprite = $AnimatedSprite2D

# Add the player to the 'player' group on ready
func _ready():
	z_index = 0 
	add_to_group("player")

func _physics_process(_delta):
	# Set up the direction of movement
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Prevent diagonal movement by setting one axis to zero if moving in one direction
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
		direction.y = 0
	elif Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		direction.x = 0
	else:
		direction = Vector2.ZERO  # No input, stop movement

	# Normalize the direction to avoid faster movement diagonally
	direction = direction.normalized()
	
	# Update the last direction if the player is moving
	if direction != Vector2.ZERO:
		last_direction = direction

	# Set up the actual movement
	velocity = direction * speed  # Assign velocity directly
	move_and_slide()  # No arguments needed

	# Play the appropriate idle animation based on the last direction
	if direction == Vector2.ZERO:
		if last_direction.x > 0:
			animation_sprite.play("idle_right")
		elif last_direction.x < 0:
			animation_sprite.play("idle_left")
		elif last_direction.y > 0:
			animation_sprite.play("idle_front")
		elif last_direction.y < 0:
			animation_sprite.play("idle_back")
	else:
		# Play the appropriate walking animation based on the current direction
		if direction.x > 0:
			animation_sprite.play("walk_right")
		elif direction.x < 0:
			animation_sprite.play("walk_left")
		elif direction.y > 0:
			animation_sprite.play("walk_front")
		elif direction.y < 0:
			animation_sprite.play("walk_back")
