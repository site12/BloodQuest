extends KinematicBody2D

var speed = 5
var velocity = 0
var timer = 3
var angle_to_player
var player
var distance = 0
var frame_timer = 10000
var other_timer = 10000
var attacking = false
var boots
var flash_timer = 0

signal hit_player(velocity)

func _ready():
	set_physics_process(true)
	player = get_parent().find_node("Player")
	$Health.connect('health_depleted', self, 'dead')
	$Area2D2.connect('area_entered', self, '_on_hit_by_fireball')

func _physics_process(delta):
	var target = get_parent().find_node("Player")
	if not attacking:
		velocity = (target.global_position - global_position).normalized()
		distance = global_position.distance_to(target.global_position)
	if distance >= 100 || attacking:
		move_and_collide(velocity*speed)

func _process(delta):
	timer -= delta
	frame_timer -= delta
	other_timer -= delta
	if timer<=0:
		speed = 0
		other_timer = 0.5
		timer = 5
	var facing = 'E'
	var angle = velocity.angle()
	if angle > PI/8 && angle < 3*PI/8:
		facing = 'SE'
	if angle > 3*PI/8 && angle < 5*PI/8:
		facing = 'S'
	if angle > 5*PI/8 && angle < 7*PI/8:
		facing = 'SW'
	if angle > 7*PI/8 && angle < PI:
		facing = 'W'
	if angle > -PI/8 && angle < PI/8:
		facing = 'E'
	if angle > -3*PI/8 && angle < -PI/8:
		facing = 'NE'
	if angle > -5*PI/8 && angle < -3*PI/8:
		facing = 'N'
	if angle > -7*PI/8 && angle < -5*PI/8:
		facing = 'NW'
	if angle > -PI && angle < -7*PI/8:
		facing = 'W'
	if frame_timer <= 0:
		speed = 5
		frame_timer = 10000
		attacking = false
	if other_timer <= 0:
		attack()
		other_timer = 10000
	$AnimatedSprite.animation = facing
	flash_timer -= delta
	if flash_timer <= 0:
		if not modulate == Color(1,1,1):
			modulate = Color(1,1,1)
	
func current_angle():
	angle_to_player = rad2deg(position.angle_to_point(player.position))
	return angle_to_player

func attack():
	$dash.play()
	attacking = true
	var player = get_parent().find_node("Player")
	var angle_to_player = rad2deg(velocity.angle_to(player.velocity))
	frame_timer = .5
	velocity = (player.global_position - global_position).normalized()
	speed = 40

func _on_hit_by_fireball(area):
	modulate = Color(1,0,0)
	flash_timer = .2
	$Health.take_damage(20)
	$get_hit.play()

func _on_Area2D_body_entered(body):
	emit_signal('hit_player', velocity)

func _get_hit(damage):
	modulate = Color(1,0,0)
	flash_timer = .2
	$get_hit.play()
	$Health.take_damage(damage)

func dead():
	get_parent().get_node('BootsBossActivator').spawnable = false
	boots = preload('res://Scenes/World/World Boots.tscn')
	boots = boots.instance()
	get_parent().add_child(boots)
	boots.position = position
	self.queue_free()