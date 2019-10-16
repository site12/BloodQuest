extends KinematicBody2D

var velocity

func _ready():
    set_physics_process(true)
    velocity = Vector2()
    $Right.connect('body_entered', self, 'pushed_left')
    $Right.connect('body_exited', self, 'no_more')
    $Left.connect('body_entered', self, 'pushed_right')
    $Left.connect('body_exited', self, 'no_more')

func _physics_process(delta):
    move_and_collide(velocity*1)

func pushed_left(area):
    velocity.x -= 2

func pushed_right(area):
    velocity.x += 2

func no_more(area):
    velocity.x = 0