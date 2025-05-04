extends VBoxContainer

func set_text(response: String, input: String):
	$Response.text = response
	$InputHistory.text = " > " + input
