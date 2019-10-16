extends Button


var a = 2

func _ready():
	disabled = true

func _process(delta):
	if a<=0:
		disabled = false
	a -= delta
