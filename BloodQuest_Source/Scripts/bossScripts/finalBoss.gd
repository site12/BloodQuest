extends KinematicBody2D


var speed = 4
var velocity=0
var timer = rand_range(1,3)
var angle_to_player = 0;
signal mana (Mana, rotation, position)
var player
var distance = 0
var teleport_timer = 5
var gold_stick
var flash_timer = 0


func _ready():
    set_physics_process(true)
    player = get_parent().find_node("Player")
    $Health.connect('health_depleted', self, 'dead')
    $Area2D.connect('area_entered', self, '_on_hit_by_fireball')
    self.connect('mana', get_parent(), '_on_finalBoss_fire')

func _physics_process(delta):
    var target = get_parent().find_node("Player")
    velocity = (target.global_position - global_position).normalized()
    distance = global_position.distance_to(target.global_position)
    if distance >= 125:
        move_and_collide(velocity*speed)
    if distance <=124:
        move_and_collide(-velocity*(speed*1.5))

func teleport():
    $teleport.play()
    position.x  = rand_range(19300,20470)
    position.y = rand_range(14480,15670)

func _process(delta):
    timer -= delta
    teleport_timer -= delta
    if teleport_timer <= 0:
        teleport()
        teleport_timer = rand_range(0,5)
    if timer<=0:
        attack()
        timer = rand_range(0,.5)
    
    var angle = velocity.angle()
    flash_timer -= delta
    if flash_timer <= 0:
        if not modulate == Color(1,1,1):
            modulate = Color(1,1,1)

    $AnimatedSprite.animation = 'default'

func _on_hit_by_fireball(area):
    $get_hit.play()
    modulate = Color(1,0,0)
    flash_timer = .2
    $Health.take_damage(20)

func _get_hit(damage):
    $get_hit.play()
    modulate = Color(1,0,0)
    flash_timer = .2
    $Health.take_damage(damage)

func current_angle():
    angle_to_player = rad2deg(position.angle_to_point(player.position))
    return angle_to_player

func attack():
    var player = get_parent().find_node("Player")
    var Mana = preload('res://Scenes/Bosses/finalBoss/Mana.tscn')
    emit_signal('mana', Mana, velocity.angle(), position)

func dead():
    gold_stick = preload('res://Scenes/World/World Gold Stick.tscn')
    var gold_stick_activator = preload('res://Scenes/Activators/GoldStickActivator.tscn')
    gold_stick = gold_stick.instance()
    gold_stick_activator = gold_stick_activator.instance()
    get_parent().add_child(gold_stick)
    get_parent().add_child(gold_stick_activator)
    gold_stick.position = get_parent().get_node('stick_podium').position
    gold_stick_activator.position = get_parent().get_node('stick_activator_position').position
    get_parent().get_node('FinalBossArenaRoof').queue_free()
    get_parent().get_node('FinalBossActivator').spawnable = false
    self.queue_free()