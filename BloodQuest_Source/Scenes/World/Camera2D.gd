extends Camera2D

export var target_name = "Player"
var target

func _ready():
    target = get_parent().find_node(target_name)  
    position = target.position
	
func _process(delta):
    target = get_parent().find_node(target_name)  
    position = target.position
