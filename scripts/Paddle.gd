extends KinematicBody2D


const ACCELERATION = 2000
const MAX_SPEED = 400
const FRICTION = -600

var input_acceleration = Vector2()
var velocity = Vector2()


func _ready():
	set_fixed_process(true)


func _fixed_process(delta):
	# determine left or right
	input_acceleration.x = Input.is_action_pressed("ui_right") - Input.is_action_pressed("ui_left")
	
	# set acceleration
	input_acceleration *= ACCELERATION
	
	# coast to a stop on no input
	if input_acceleration.x == 0:
		input_acceleration += velocity * (FRICTION * delta)
	
	# update current velocity
	velocity += input_acceleration * delta
	
	# limit to max speed
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	# move paddle
	var motion = move(velocity * delta)


