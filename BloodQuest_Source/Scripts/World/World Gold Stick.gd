extends Area2D

signal win
var player

func _ready():
    player = get_parent().find_node('Player')
    player.connect('gold_stick_picked_up', self, '_on_Player_gold_stick_picked_up')
    self.connect('body_entered', player, '_on_World_Gold_Stick_body_entered')
    

func _on_Player_gold_stick_picked_up():
    hide()
    $CollisionShape2D.call_deferred('set_disabled', true)
    var end = preload('res://credits.tscn')
    end = end.instance()
    get_parent().add_child(end)
