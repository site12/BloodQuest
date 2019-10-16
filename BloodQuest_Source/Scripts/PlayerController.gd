extends KinematicBody2D


export var default_speed = 400
export var direction = 0;

var speed = 400  # How fast the player will move (pixels/sec).
var weapons = []
var equipped = ''
var facing
var velocity
var dash_timer = 0
var frame_timer = 0
var fire_timer = 0
var knockback = null
var dashing = false
var angle_changed = false
var dead = preload('res://dead.tscn')

signal stick_picked_up
signal sword_picked_up
signal fire_picked_up
signal dagger_picked_up
signal boots_picked_up
signal shield_picked_up
signal fire(Fire, rotation, position)
signal hit_enemy(damage)
signal gold_stick_picked_up

func _ready():
    dead = dead.instance()
    $AnimatedSprite.connect('frame_changed', self, 'new_frame')
    

func current_angle():
    return get_global_mouse_position().angle_to_point(get_position())
    
func update_direction():
    var angle = current_angle()
    var last_face = facing
    if angle > PI/8 && angle < 3*PI/8:
        facing = '315'
    if angle > 3*PI/8 && angle < 5*PI/8:
        facing = '270'
    if angle > 5*PI/8 && angle < 7*PI/8:
        facing = '225'
    if angle > 7*PI/8 && angle < PI:
        facing = '180'
    if angle > -PI/8 && angle < PI/8:
        facing = '0'
    if angle > -3*PI/8 && angle < -PI/8:
        facing = '45'
    if angle > -5*PI/8 && angle < -3*PI/8:
        facing = '90'
    if angle > -7*PI/8 && angle < -5*PI/8:
        facing = '135'
    if angle > -PI && angle < -7*PI/8:
        facing = '180'
    if last_face != facing:
        angle_changed
    if not dashing:
        $AnimatedSprite.animation = facing
    
#use _input for any inputs that need to be instant (mostly just mouse)
func _input(event):
    if event.is_action_pressed('click'):
        attack(event.position)
    if event.is_action_pressed('zoom_in'):
        if len(weapons) >= 2:
            var prev_item = weapons.find(equipped)-1
            if prev_item < 0:
                prev_item = len(weapons)-1
            equipped = weapons[prev_item]
            
    if event.is_action_pressed('zoom_out'):
        if len(weapons) >= 2:
            var next_item = weapons.find(equipped)+1
            if next_item > len(weapons)-1:
                next_item = 0
            equipped = weapons[next_item]


func pickup_item(item):
    weapons.append(item)
    if len(weapons) == 1:
        equipped = item
    emit_signal(item +'_picked_up')

func _on_World_Sword_body_entered(body):
    pickup_item('sword')
    $player_hit.play()
    $Health.take_damage(20)
    
func _on_World_Stick_body_entered(body):
    pickup_item('stick')
    $player_hit.play()
    $Health.take_damage(5)

func _on_World_Fire_body_entered(body):
    pickup_item('fire')
    $player_hit.play()
    $Health.take_damage(20)

func _on_World_Dagger_body_entered(body):
    pickup_item('dagger')
    $player_hit.play()
    $Health.take_damage(10)

func _on_World_Boots_body_entered(body):
    $Health.take_damage(10)
    $player_hit.play()
    emit_signal('boots_picked_up')
    default_speed = 600

func _on_World_Shield_body_entered(body):
    $Health.take_damage(30)
    $player_hit.play()
    $Health.shield = true
    emit_signal('shield_picked_up')

func _on_World_Gold_Stick_body_entered(body):
    pickup_item('gold_stick')
    
func dash():
    dashing = true
    var angle = current_angle()
    var rot
    frame_timer = 5
    $AnimatedSprite.animation = 'Dash'
    if angle > PI/8 && angle < 3*PI/8:
        rot = PI/4
    if angle > 3*PI/8 && angle < 5*PI/8:
        rot = PI/2
        $AnimatedSprite.frame = 1
    if angle > 5*PI/8 && angle < 7*PI/8:
        rot = 3*PI/4
    if angle > 7*PI/8 && angle < PI:
        rot = PI
        $AnimatedSprite.frame = 2
    if angle > -PI/8 && angle < PI/8:
        rot = 0
        $AnimatedSprite.frame = 3
    if angle > -3*PI/8 && angle < -PI/8:
        rot = -PI/4
    if angle > -5*PI/8 && angle < -3*PI/8:
        rot = -PI/2
        $AnimatedSprite.frame = 0
    if angle > -7*PI/8 && angle < -5*PI/8:
        rot = -3*PI/4
    if angle > -PI && angle < -7*PI/8:
        rot = -PI
        $AnimatedSprite.frame = 2
    velocity.x = cos(rot)
    velocity.y = sin(rot)
    speed *= 10
    $dash.play()

func attack(spot):
    if equipped == 'stick':
        $swing_pivot.rotation = direction.angle()+PI/2
        $swing_pivot.get_node('swing').animation = 'wood'
        $swing_pivot.get_node('swing').frame = 0
        $swing_pivot.show()
        $swing_pivot.get_node('swing').play()
        $stick_swing.play()
        for node in get_tree().get_nodes_in_group('enemy'):
            if position.distance_to(node.position) < 200:
                var angle_to_enemy = rad2deg(direction.angle_to(node.velocity))
                if abs(angle_to_enemy) < 202.5 && abs(angle_to_enemy) > 157.5:
                    emit_signal('hit_enemy', 20)

    if equipped == 'sword':
        $swing_pivot.rotation = direction.angle()+PI/2
        $swing_pivot.get_node('swing').animation = 'metal'
        $swing_pivot.get_node('swing').frame = 0
        $swing_pivot.show()
        $swing_pivot.get_node('swing').play()
        $sword_swing.play()
        for node in get_tree().get_nodes_in_group('enemy'):
            if position.distance_to(node.position) < 250:
                var angle_to_enemy = rad2deg(direction.angle_to(node.velocity))
                if abs(angle_to_enemy) < 202.5 && abs(angle_to_enemy) > 157.5:
                    emit_signal('hit_enemy', 40)

    if equipped == 'dagger':
        $swing_pivot.rotation = direction.angle()+PI/2
        $swing_pivot.get_node('swing').animation = 'metal'
        $swing_pivot.get_node('swing').frame = 0
        $swing_pivot.show()
        $swing_pivot.get_node('swing').play()
        $sword_swing.play()
        for node in get_tree().get_nodes_in_group('enemy'):
            if position.distance_to(node.position) < 150:
                var direction = (get_global_mouse_position()-position).normalized()
                var angle_to_enemy = rad2deg(direction.angle_to(node.velocity))
                if abs(angle_to_enemy) < 202.5 && abs(angle_to_enemy) > 157.5:
                    emit_signal('hit_enemy', 30)

    if equipped == 'fire':
        if fire_timer <= 0:
            var Fire = preload('res://Scenes/Player/Fire.tscn')
            emit_signal('fire', Fire, current_angle(), position)
            fire_timer = 0.5


func _process(delta):
    # The player's movement vector.
    velocity = Vector2()
    dash_timer -= delta
    fire_timer -= delta
    if Input.is_action_pressed("right"):
        velocity.x += 1
    if Input.is_action_pressed("left"):
        velocity.x -= 1
    if Input.is_action_pressed("down"):
        velocity.y += 1
    if Input.is_action_pressed("up"):
        velocity.y -= 1
    if Input.is_action_pressed('dash'):
        if dash_timer <= 0:
            dash()
            dash_timer = 1
    if Input.is_action_pressed('one'):
        if len(weapons) >= 1:
            equipped = weapons[0]
    if Input.is_action_pressed('two'):
        if len(weapons) >= 2:
            equipped = weapons[1]
    if Input.is_action_pressed('three'):
        if len(weapons) >= 3:
            equipped = weapons[2]
    if Input.is_action_pressed('four'):
        if len(weapons) >= 4:
            equipped = weapons[3]
    update_direction()
    direction = (get_global_mouse_position()-position).normalized()
    if knockback != null:
        $AnimatedSprite.stop()
        velocity = knockback.normalized() * speed
        move_and_collide(velocity*delta)
    elif velocity.length() > 0: #if the length of the vector is greater than 0
        $AnimatedSprite.play()
        velocity = velocity.normalized() * speed #sets the player's velocity
    else: 
        $AnimatedSprite.animation = 'Idles'
        match facing:
            '0':
                $AnimatedSprite.frame = 7
            '90':
                $AnimatedSprite.frame = 4
            '180':
                $AnimatedSprite.frame = 6
            '270':
                $AnimatedSprite.frame = 5
            '45':
                $AnimatedSprite.frame = 0
            '135':
                $AnimatedSprite.frame = 1
            '225':
                $AnimatedSprite.frame = 2
            '315':
                $AnimatedSprite.frame = 3
        $AnimatedSprite.stop()
    move_and_collide(velocity*delta)#moves the player
    frame_timer -= 1
    if frame_timer <= 0:
        speed = default_speed
        knockback = null
        dashing = false
    
func new_frame():
    if not $AnimatedSprite.animation == 'Idles':
        if $AnimatedSprite.frame == 1 || $AnimatedSprite.frame == 6:
            $footstep.pitch_scale = rand_range(1,1.5)
            $footstep.play()

    
#detect and take damage from fireballs
func _on_Hitbox_area_entered(area):
    $player_hit.play()
    $Health.take_damage(10)
    
func _on_bootsBoss_hit_player(velocity):
    $bash.play()
    $Health.take_damage(10)
    knockback = velocity
    speed = 800
    frame_timer = 5

func _on_SwordBoss_hit_player():
    $player_hit.play()
    $Health.take_damage(20)

func _on_Health_health_depleted():
    get_parent().add_child(dead)
