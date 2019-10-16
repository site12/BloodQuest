extends CanvasLayer

var a = 25

func _process(delta):
	if a<=0:
		get_tree().change_scene("res://Scenes/World/OverWorld.tscn")
	a-=delta
