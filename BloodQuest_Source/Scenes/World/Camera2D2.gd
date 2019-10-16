extends Camera2D

export var target = "Player"

func _ready():
    target = get_parent().find_node(target)   
    position = target.position
	
func _process(delta):
    position = target.position