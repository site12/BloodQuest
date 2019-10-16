extends Area2D

func _ready():
    self.connect('body_entered', get_parent().get_parent(), 'crate_here')
    self.connect('body_exited', get_parent().get_parent(), 'crate_gone')