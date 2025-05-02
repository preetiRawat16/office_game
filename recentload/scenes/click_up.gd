extends Control

@onready var StacyMeet = $TextureRect/StacyMeet
@onready var AliceMeet = $TextureRect/AliceMeet
@onready var HrMeet = $TextureRect/HRMeet
@onready var ITMeet = $TextureRect/ITMeet
@onready var f = $TextureRect/finaltext
@onready var AcceptDialogue = $AcceptDialog 

func _ready():
	f.visible = false
	
	# Set checkboxes based on Global values
	StacyMeet.button_pressed = Global.stacycheck
	AliceMeet.button_pressed = Global.alicecheck
	HrMeet.button_pressed = Global.hrcheck
	ITMeet.button_pressed = Global.itcheck
	
	# Connect signals
	StacyMeet.toggled.connect(_on_StacyMeet_toggled)
	AliceMeet.toggled.connect(_on_AliceMeet_toggled)
	HrMeet.toggled.connect(_on_HrMeet_toggled)
	ITMeet.toggled.connect(_on_ITMeet_toggled)

	# Final scene state
	if Global.sceneChange == "finalscene":
		set_all_meetings_complete()

func _on_StacyMeet_toggled(pressed: bool) -> void:
	if pressed and not Global.meetStacy:
		await get_tree().process_frame
		StacyMeet.button_pressed = false
		show_warning("You haven't met Stacy yet!\n\nMarking a task as complete without actually finishing it can lead to confusion, missed responsibilities, and delays in project progress. At Mocha Tech, we place a strong emphasis on accountability and integrity in our workflow. Skipping steps or prematurely checking items off not only undermines the process but is also viewed as a serious concern by the team. Let’s all maintain high standards and ensure our work reflects our shared commitment to quality and reliability.")
	else:
		Global.stacycheck = pressed
	check_all_meetings()

func _on_AliceMeet_toggled(pressed: bool) -> void:
	if pressed and not Global.meetAlice:
		await get_tree().process_frame
		AliceMeet.button_pressed = false
		show_warning("You haven't met Alice yet!\n\nMarking a task as complete without actually finishing it can lead to confusion, missed responsibilities, and delays in project progress. At Mocha Tech, we place a strong emphasis on accountability and integrity in our workflow. Skipping steps or prematurely checking items off not only undermines the process but is also viewed as a serious concern by the team. Let’s all maintain high standards and ensure our work reflects our shared commitment to quality and reliability.")
	else:
		Global.alicecheck = pressed
	check_all_meetings()

func _on_HrMeet_toggled(pressed: bool) -> void:
	Global.hrcheck = pressed
	check_all_meetings()

func _on_ITMeet_toggled(pressed: bool) -> void:
	Global.itcheck = pressed
	check_all_meetings()

func check_all_meetings() -> void:
	if StacyMeet.button_pressed and AliceMeet.button_pressed and HrMeet.button_pressed and ITMeet.button_pressed:
		f.visible = true
		Global.sceneChange = "finalscene"
		print(Global.sceneChange)

func show_warning(message: String) -> void:
	print(message)
	AcceptDialogue.dialog_text = message
	AcceptDialogue.popup_centered() # Replace with popup dialog if needed

func set_all_meetings_complete() -> void:
	StacyMeet.button_pressed = true
	AliceMeet.button_pressed = true
	ITMeet.button_pressed = true
	HrMeet.button_pressed = true
	f.visible = true
	
	Global.stacycheck = true
	Global.alicecheck = true
	Global.itcheck = true
	Global.hrcheck = true
