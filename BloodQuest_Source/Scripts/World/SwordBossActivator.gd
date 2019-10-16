extends Area2D

var Boss
var boss
var Player
var audioMain
var audioSword
export var spawnable = true

func _ready():
    Boss = preload('res://Scenes/Bosses/swordBoss/SwordBoss.tscn')
    boss = Boss.instance()
    Player = get_parent().find_node('Player')
    audioMain = get_parent().find_node('AudioMain')
    audioSword = get_parent().find_node('AudioSword')
    self.connect('body_entered',audioMain,"boss")
    self.connect('body_exited',audioMain,"notBoss")
    self.connect('body_entered',audioSword,"boss")
    self.connect('body_exited',audioSword,"notBoss")

func _on_SwordBossActivator_body_entered(body):
    if spawnable:
        get_parent().add_child(boss)
        boss.position = get_parent().get_node('SwordBossCamera').position
        boss.connect('hit_player', Player, '_on_SwordBoss_hit_player')
        Player.connect('hit_enemy', boss, '_get_hit')
    get_parent().get_node('Camera2D').target_name = 'SwordBossCamera'
    get_parent().get_node('Camera2D').zoom.x = 2.2
    get_parent().get_node('Camera2D').zoom.y = 2.2

func _on_SwordBossActivator_body_exited(body):
    if spawnable:
        get_parent().remove_child(boss)
    get_parent().get_node('Camera2D').target_name = 'Player'
    get_parent().get_node('Camera2D').zoom.x = 1.25
    get_parent().get_node('Camera2D').zoom.y = 1.25
    