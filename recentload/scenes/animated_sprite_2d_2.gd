extends AnimatedSprite2D

func _process(_delta):
	if Global.sceneChange == "clickupstarts":
		visible = true
		if not is_playing():
			play()
	else:
		visible = false
