extends KinematicBody2D


var speed = 1
var velocity = 0
var timer = 3
var angle_to_player
var player
var distance =0
var attack_timer = 80000
var sword
var Sword
var flash_timer = 0
signal hit_player

func _ready():
	set_physics_process(true)
	$Health.connect('health_depleted', self, 'dead')
	player = get_parent().find_node("Player")
	$Area2D.connect('area_entered', self, '_on_hit_by_fireball')

func _physics_process(delta):
	var target = get_parent().find_node("Player")
	velocity = (target.global_position - global_position).normalized()
	distance = global_position.distance_to(target.global_position)
	if distance >= 100:
		move_and_collide(velocity*speed)
	
func _process(delta):
	attack_timer -= delta
	timer -= delta
	if timer<=0:
		if distance <= 150:
			attack_timer = .2
			speed = 0
			attack_timer = .2
			speed = 0
		timer = rand_range(0,2)
	if attack_timer <= 0:
		attack_timer = 80000
		attack()
		speed = 1
	$AnimatedSprite.animation = 'default'
	flash_timer -= delta
	if flash_timer <= 0:
		if not modulate == Color(1,1,1):
			modulate = Color(1,1,1)
	# modulate = Color(1,1,1)

func current_angle():
	angle_to_player = rad2deg(position.angle_to_point(player.position))
	return angle_to_player

func _on_hit_by_fireball(area):
	modulate = Color(1,0,0)
	flash_timer = .2
	$Health.take_damage(20)
	$get_hit.play()

func attack():
	$swing_pivot.rotation = deg2rad(current_angle())-PI/2
	$swing_pivot.get_node('swing').animation = 'metal'
	$swing_pivot.get_node('swing').frame = 0
	$swing_pivot.show()
	$swing_pivot.get_node('swing').play()
	$sword_swing.play()
	if position.distance_to(player.global_position) < 150:
        emit_signal('hit_player')

func _get_hit(damage):
	modulate = Color(1,0,0)
	flash_timer = .2
	$get_hit.play()
	$Health.take_damage(damage)

func dead():
	get_parent().get_node('SwordBossActivator').spawnable = false
	Sword = preload('res://Scenes/World/World Sword.tscn')
	sword = Sword.instance()
	get_parent().add_child(sword)
	sword.position = position
	self.queue_free()

