extends KinematicBody2D


export (int, "constant", "momentum") var motion_type

var paddle


func _ready():
	# turn on fixed step processing
	set_fixed_process(true)
	
	# determine the paddle class to use
	if motion_type == 0: # constant motion
		paddle = ConstantPaddle.new()
	else: # momentum motion
		paddle = MomentumPaddle.new()


func _fixed_process(delta):
	# get the motion from the paddle class
	var motion = paddle.get_motion(delta)
	# move the paddle
	move(motion)




class ConstantPaddle:
	
	
	const SPEED = 400 
	
	
	func get_motion(delta):
		# check for input; value will be 1 if input is pressed
		var going_right = Input.is_action_pressed("ui_right") 
		var going_left = Input.is_action_pressed("ui_left") 
		
		var velocity = Vector2(0, 0)
		# calculate velocity direction
		velocity.x = going_right - going_left
		# calculate velocity length
		velocity *= SPEED
		
		# return the movement for the current tick 
		# using velocity (units per seconds) and delta (seconds)
		return velocity * delta




class MomentumPaddle:
	
	
	const ACCELERATION = 2000
	const MAX_SPEED = 400
	const FRICTION = -600
	
	var velocity = Vector2()
	
	
	func get_motion(delta):
		# check for input; value will be 1 if input is pressed
		var going_right = Input.is_action_pressed("ui_right") 
		var going_left = Input.is_action_pressed("ui_left") 
		
		var input_acceleration = Vector2(0, 0)
		# calculate acceleration direction
		input_acceleration.x = going_right - going_left
		# calculate acceleration length
		input_acceleration *= ACCELERATION
		
		if input_acceleration.x == 0: # paddle isn't moving
			# calculate acceleration from current velocity reduced by friction
			input_acceleration += velocity * (FRICTION * delta)
		
		# update current velocity by acceleration
		velocity += input_acceleration * delta
		
		# limit velocity to max speed
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
		
		# return the movement for the current tick 
		# using velocity (units per seconds) and delta (seconds)
		return velocity * delta

