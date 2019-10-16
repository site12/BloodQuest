extends KinematicBody2D


var speed = 2
var velocity=0
var timer = rand_range(1,3)
var angle_to_player = 0;
signal fire (Fire, rotation, position)
var player
var distance = 0
var flash_timer = 0

func _ready():
	set_physics_process(true)
	player = get_parent().find_node("Player")
	$Health.connect('health_depleted', self, 'dead')
	$Area2D.connect('area_entered', self, '_on_hit_by_fireball')
	$AnimatedSprite.play()

func _physics_process(delta):
	var target = get_parent().find_node("Player")
	velocity = (target.global_position - global_position).normalized()
	distance = global_position.distance_to(target.global_position)
	if distance >= 125:
		move_and_collide(velocity*speed)
	if distance <=124: #&& distance > 75:
		move_and_collide(-velocity*(speed*1.5))  

func _process(delta):
	timer -= delta
	if timer<=0:
		attack()
		timer = rand_range(0,1)
	var facing = 'E'
	var angle = velocity.angle()
	flash_timer -= delta
	if flash_timer <= 0:
		if not modulate == Color(1,1,1):
			modulate = Color(1,1,1)
	$AnimatedSprite.animation = facing

func _on_hit_by_fireball(area):
	$get_hit.play()
	modulate = Color(1,0,0)
	flash_timer = .2
	$Health.take_damage(20)

func current_angle():
	angle_to_player = rad2deg(position.angle_to_point(player.position))
	return angle_to_player

func attack():
    var player = get_parent().find_node("Player")
    var Fire = preload('res://Scenes/Bosses/fireBoss/MeanGuyFire.tscn')
    emit_signal('fire', Fire, velocity.angle(), position)

func _get_hit(damage):
	$get_hit.play()
	modulate = Color(1,0,0)
	flash_timer = .2
	$Health.take_damage(damage)

func dead():
	get_parent().get_node('FireBossActivator').spawnable = false
	var fire = preload('res://Scenes/World/World Fire.tscn')
	fire = fire.instance()
	get_parent().add_child(fire)
	fire.position = position
	self.queue_free()
