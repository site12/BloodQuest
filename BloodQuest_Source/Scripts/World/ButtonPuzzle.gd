extends Node2D

var pattern = [1, 2, 3, 4]
var player_pattern = []
var spawnable = true

func _ready():
    $Button1.connect('body_entered', self, 'button1_depressed')
    $Button2.connect('body_entered', self, 'button2_depressed')
    $Button3.connect('body_entered', self, 'button3_depressed')
    $Button4.connect('body_entered', self, 'button4_depressed')

func button1_depressed(body):
    if not $Button1.pressed:
        player_pattern.append(1)
        $Button1.get_node('AnimatedSprite').frame = 1
        $Button1.pressed = true
    if len(player_pattern) == 4:
        check()
    

func button2_depressed(body):
    if not $Button2.pressed:
        player_pattern.append(2)
        $Button2.get_node('AnimatedSprite').frame = 1
        $Button2.pressed = true
    if len(player_pattern) == 4:
        check()
    

func button3_depressed(body):
    if not $Button3.pressed:
        player_pattern.append(3)
        $Button3.get_node('AnimatedSprite').frame = 1
        $Button3.pressed = true
    if len(player_pattern) == 4:
        check()
    

func button4_depressed(body):
    if not $Button4.pressed:
        player_pattern.append(4)
        $Button4.get_node('AnimatedSprite').frame = 1
        $Button4.pressed = true
    if len(player_pattern) == 4:
        check()
    

func check():
    if not player_pattern == pattern:
        $Button1.get_node('AnimatedSprite').frame = 0
        $Button2.get_node('AnimatedSprite').frame = 0
        $Button3.get_node('AnimatedSprite').frame = 0
        $Button4.get_node('AnimatedSprite').frame = 0
        $Button1.pressed = false
        $Button2.pressed = false
        $Button3.pressed = false
        $Button4.pressed = false
        player_pattern.clear()
    elif player_pattern == pattern:
        if spawnable:
            var dagger = preload('res://Scenes/World/World Dagger.tscn')
            dagger = dagger.instance()
            get_parent().add_child(dagger)
            dagger.position = position
            spawnable = false