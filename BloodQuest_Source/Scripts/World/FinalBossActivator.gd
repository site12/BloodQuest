extends Area2D

var Boss
var boss
var Player
var audioMain
var audioFinal
export var spawnable = true

func _ready():
    Boss = preload('res://Scenes/Bosses/finalBoss/finalBoss.tscn')
    boss = Boss.instance()
    Player = get_parent().find_node('Player')
    audioMain = get_parent().find_node('AudioMain')
    audioFinal = get_parent().find_node('AudioFinal')
    self.connect('body_entered', self, '_on_FinalBossActivator_body_entered')
    self.connect('body_exited', self, '_on_FinalBossActivator_body_exited')
    self.connect('body_entered',audioMain,"boss")
    self.connect('body_exited',audioMain,"notBoss")
    self.connect('body_entered',audioFinal,"boss")
    self.connect('body_exited',audioFinal,"notBoss")

func _on_FinalBossActivator_body_entered(body):
    if spawnable:
        get_parent().add_child(boss)
        boss.position = get_parent().get_node('FinalBossCamera').position
        boss.connect('mana', get_parent(), '_on_finalBoss_fire')
        Player.connect('hit_enemy', boss, '_get_hit')
    get_parent().get_node('Camera2D').target_name = 'FinalBossCamera'
    get_parent().get_node('Camera2D').zoom.x = 3.25
    get_parent().get_node('Camera2D').zoom.y = 3.25

func _on_FinalBossActivator_body_exited(body):
    if spawnable:
        get_parent().remove_child(boss)
    get_parent().get_node('Camera2D').target_name = 'Player'
    get_parent().get_node('Camera2D').zoom.x = 1.25
    get_parent().get_node('Camera2D').zoom.y = 1.25