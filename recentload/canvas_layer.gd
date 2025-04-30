extends CanvasLayer

# Variables to hold references to the Panel and Label
var panel: Panel
var label: Label

func _ready():
	# Create the Panel
	panel = Panel.new()
	panel.size = Vector2(400, 100)  # Set the size of the panel
	panel.position = Vector2(200, 500)  # Position the panel at the bottom of the screen
	add_child(panel)  # Add the panel to the CanvasLayer

	# Create the Label
	label = Label.new()
	label.text = "Hello World"  # Default text
	label.position = Vector2(20, 20)  # Position the label inside the panel
	panel.add_child(label)  # Add the label to the panel

	# Hide the dialogue box by default
	visible = false

func show_dialogue(message: String):
	label.text = message  # Update the label text
	visible = true        # Show the dialogue box

func hide_dialogue():
	visible = false       # Hide the dialogue box
