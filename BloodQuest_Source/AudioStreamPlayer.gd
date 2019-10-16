extends AudioStreamPlayer


var a = -50
var b = false
export var speed = 20

func _ready():
	playing = true
	autoplay = true

func _process(delta):
	
	if !a>=0&&!b:
		a += delta*speed
	set_volume_db(a)
	
func boss(area):
	b = true
	a = -50
	
func notBoss(area):
	b = false
	a = -50