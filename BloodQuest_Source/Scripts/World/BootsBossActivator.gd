extends Area2D

var Boss
var boss
var Player
var audioMain
var audioBoots
export var spawnable = true

func _ready():
	Boss = preload('res://Scenes/Bosses/bootsBoss/bootsBoss.tscn')
	boss = Boss.instance()
	Player = get_parent().find_node('Player')
	audioMain = get_parent().find_node('AudioMain')
	audioBoots = get_parent().find_node('AudioBoots')
	self.connect('body_entered',audioMain,"boss")
	self.connect('body_exited',audioMain,"notBoss")
	self.connect('body_entered',audioBoots,"boss")
	self.connect('body_exited',audioBoots,"notBoss")
	
func _on_BootsBossActivator_body_entered(body):
	if spawnable:
		get_parent().add_child(boss)
		boss.connect('hit_player', get_parent().find_node('Player'), '_on_bootsBoss_hit_player')
		boss.position = get_parent().get_node('BootsBossCamera').position
		Player.connect('hit_enemy', boss, '_get_hit')
	get_parent().get_node('Camera2D').target_name = 'BootsBossCamera'
	get_parent().get_node('Camera2D').zoom.x = 2
	get_parent().get_node('Camera2D').zoom.y = 2

func _on_BootsBossActivator_body_exited(body):
	if spawnable:
		get_parent().remove_child(boss)
	get_parent().get_node('Camera2D').target_name = 'Player'
	get_parent().get_node('Camera2D').zoom.x = 1.25
	get_parent().get_node('Camera2D').zoom.y = 1.25
