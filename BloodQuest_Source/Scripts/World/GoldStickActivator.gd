extends Area2D


var Player
var camera
var in_zone = false
var zoom
var podium

func _ready():
    Player = get_parent().find_node('Player')
    camera = get_parent().find_node('Camera2D')
    podium = get_parent().get_node('stick_podium')
    self.connect('body_entered', self, '_on_GoldStickActivator_body_entered')
    self.connect('body_exited', self, '_on_GoldStickActivator_body_exited')
	
func _process(delta):
    if in_zone:
        camera.target_name = 'stick_podium'
        zoom = clamp(podium.position.distance_to(Player.position)/300, 0.75, 4)
        camera.zoom.x = zoom
        camera.zoom.y = zoom

func _on_GoldStickActivator_body_entered(body):
    in_zone = true

func _on_GoldStickActivator_body_exited(body):
    in_zone = false
    get_parent().get_node('Camera2D').target_name = 'Player'
    get_parent().get_node('Camera2D').zoom.x = 1.25
    get_parent().get_node('Camera2D').zoom.y = 1.25