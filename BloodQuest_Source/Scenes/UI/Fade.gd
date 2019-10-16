extends CanvasLayer

func _ready():
	get_tree().paused = true

func _process(delta):
	var timer = 2
	if(timer<=0):
		get_parent().remove_child(self)
	timer -= delta

func _on_Button_pressed():
	get_tree().paused = false
	self.queue_free()
