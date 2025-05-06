extends Control

@onready var HR_Result = Global.hrtask_result
@onready var SQL_Result = Global.sqltask_result
@onready var EMAIL_Result = Global.emailtask_result
@onready var Clickup_Result = Global.clickuptask_result
@onready var DisplayResult = $TextureRect/RichTextLabel

func _ready():
	print("HR:", HR_Result)
	print("SQL:", SQL_Result)
	print("Email:", EMAIL_Result)

	DisplayResult.text = ""  # Clear first if needed
	DisplayResult.text += "  Document Submission Score: %s%%\n" % HR_Result
	DisplayResult.text += "  SQL Test Score: %s%%\n" % SQL_Result
	DisplayResult.text += "  Email Test Score: %s%%\n" % EMAIL_Result
	DisplayResult.text += "  Breaking code of conduct: %s points lost\n\n" % Clickup_Result
	
	var hr = int(HR_Result)
	var sql = int(SQL_Result)
	var email = int(EMAIL_Result)
	var clickup = int(Clickup_Result)
	
	if clickup > 100:
		clickup = 100
	
	var totalscore = int(((hr + sql + email) - clickup) * 100 / 300)
	DisplayResult.text += "               Total GAM Score: %d%%\n" % totalscore


func _on_prebutton_pressed() -> void:
	var form_url = "https://forms.gle/3voizNi7xJMReYKb9" # Replace with function body.
	OS.shell_open(form_url)


func _on_postbutton_pressed() -> void:
	var form_url = "https://forms.gle/BrbeB7BcuD4YmgWM7" # Replace with function body.
	OS.shell_open(form_url)
