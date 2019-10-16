extends Area2D

export var velocity = Vector2()

func _ready():
	$fireball_effect.pitch_scale = rand_range(1,1.5)
	$fireball_effect.play()

func _process(delta):
	if velocity.length() > 0: 
        velocity = velocity.normalized() * 500 
	position += (velocity*delta)
	
func _on_Visibility_screen_exited():
	queue_free()