extends CanvasLayer

func _ready():
	get_tree().paused = true



func _on_TextureButton_pressed():
	get_tree().paused = false
	

