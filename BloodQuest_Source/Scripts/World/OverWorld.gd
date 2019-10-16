extends Node2D


var crate_counter = 0
var shield_released = false

func _ready():
	randomize()

func _on_Player_fire(Fire, angle, position):
	var f = Fire.instance()
	var rot = 0
	add_child(f)
	if angle > PI/8 && angle < 3*PI/8:
	    rot = PI/4
	if angle > 3*PI/8 && angle < 5*PI/8:
	    rot = PI/2
	if angle > 5*PI/8 && angle < 7*PI/8:
	    rot = 3*PI/4
	if angle > 7*PI/8 && angle < PI:
	    rot = PI
	if angle > -PI/8 && angle < PI/8:
	    rot = 0
	if angle > -3*PI/8 && angle < -PI/8:
	    rot = -PI/4
	if angle > -5*PI/8 && angle < -3*PI/8:
	    rot = -PI/2
	if angle > -7*PI/8 && angle < -5*PI/8:
	    rot = -3*PI/4
	if angle > -PI && angle < -7*PI/8:
	    rot = -PI
	f.rotation = rot
	f.position = position
	f.velocity.x = cos(rot)
	f.velocity.y = sin(rot)

func _on_fireBoss_fire(Fire, angle, position):
	var f = Fire.instance()
	var rot = 0
	add_child(f)
	if angle > PI/8 && angle < 3*PI/8:
	    rot = PI/4
	if angle > 3*PI/8 && angle < 5*PI/8:
	    rot = PI/2
	if angle > 5*PI/8 && angle < 7*PI/8:
	    rot = 3*PI/4
	if angle > 7*PI/8 && angle < PI:
	    rot = PI
	if angle > -PI/8 && angle < PI/8:
	    rot = 0
	if angle > -3*PI/8 && angle < -PI/8:
	    rot = -PI/4
	if angle > -5*PI/8 && angle < -3*PI/8:
	    rot = -PI/2
	if angle > -7*PI/8 && angle < -5*PI/8:
	    rot = -3*PI/4
	if angle > -PI && angle < -7*PI/8:
	    rot = -PI
	f.rotation = rot
	f.position = position
	f.velocity.x = cos(rot)
	f.velocity.y = sin(rot)
	
func _on_finalBoss_fire(Mana, angle, position):
	var m = Mana.instance()
	var rot = 0
	add_child(m)
	if angle > PI/8 && angle < 3*PI/8:
	    rot = PI/4
	if angle > 3*PI/8 && angle < 5*PI/8:
	    rot = PI/2
	if angle > 5*PI/8 && angle < 7*PI/8:
	    rot = 3*PI/4
	if angle > 7*PI/8 && angle < PI:
	    rot = PI
	if angle > -PI/8 && angle < PI/8:
	    rot = 0
	if angle > -3*PI/8 && angle < -PI/8:
	    rot = -PI/4
	if angle > -5*PI/8 && angle < -3*PI/8:
	    rot = -PI/2
	if angle > -7*PI/8 && angle < -5*PI/8:
	    rot = -3*PI/4
	if angle > -PI && angle < -7*PI/8:
	    rot = -PI
	m.rotation = rot
	m.position = position
	m.velocity.x = cos(rot)
	m.velocity.y = sin(rot)

func crate_here(area):
	crate_counter += 1
	if crate_counter == 3:
		if not shield_released:
			var shield = preload('res://Scenes/World/World Shield.tscn')
			shield = shield.instance()
			add_child(shield)
			shield.position = $shield_spawn_point.position
			shield_released = true

func crate_gone(area):
	crate_counter -= 1