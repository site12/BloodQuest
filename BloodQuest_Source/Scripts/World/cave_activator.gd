extends Area2D

func _ready():
    self.connect('body_entered', self, 'player_entered')
    self.connect('body_exited', self, 'player_exited')

func player_entered(area):
    get_parent().get_node('CaveRoof').hide()
    get_parent().get_node('CaveRoofTrim').hide()

func player_exited(area):
    get_parent().get_node('CaveRoof').show()
    get_parent().get_node('CaveRoofTrim').show()