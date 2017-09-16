extends KinematicBody2D


const BALL_SPEED = 300
const PADDLE_INFLUENCE = 5

var velocity = Vector2()
var held = true
var hold_position

onready var sound_effects = get_node("SoundEffects")
onready var trail = get_node("Trail")


func _ready():
	# turn on fixed step processing
	set_fixed_process(true)
	# turn on input handling
	set_process_input(true)
	
	# randomize the randon generator seed
	randomize()
	
	# set the initial velocity going straight upwards
	var initial_velocity = Vector2(0, -BALL_SPEED)
	# generate a random angle between -30 degrees and 30 degrees
	var angle = rand_range(-30, 30)
	# convert the angle to radians
	var radian = deg2rad(angle)
	# rotate the initial velocity by the random angle
	velocity = initial_velocity.rotated(radian)


func _fixed_process(delta):
	if held: # ball stays at a fixed position
		# turn off the particle trail while the ball is held
		trail.set_emitting(false)
		if hold_position: # if hold position exists
			# move the ball to the hold position's location
			set_pos(hold_position.get_global_pos())
		# leave the function to prevent the ball from moving
		return
	
	# calculation the movement for the current tick 
	# using velocity (units per seconds) and delta (seconds)
	var motion = velocity * delta
	# move the ball
	move(motion)
	
	if is_colliding(): # something was hit
		# determine normal of the body struck
		var normal = get_collision_normal()
		# reflect the velocity using that normal
		velocity = normal.reflect(velocity)
		
		# check what was hit
		var body = get_collider()
		if body.is_in_group("Blocks"): # hit a block
			# Let the block know it was hit
			body.hit() 
			# play the block hit sound
			sound_effects.play("BlockHit")
		elif body.get_name() == "Paddle": # hit the paddle
			var distance = Vector2()
			# calculate the distance of the ball from center of paddle
			distance.x = get_pos().x - body.get_global_pos().x
			# calculate the amount of horizontal influence
			var influence = distance * PADDLE_INFLUENCE
			# apply the horizontal influence on the current velocity
			velocity += influence
			# reset the ball speed
			velocity = velocity.normalized() * BALL_SPEED
			# play the paddle hit sound
			sound_effects.play("PaddleHit")
		else:
			# play the wall hit sound
			sound_effects.play("WallHit")


func _input(event):
	if held and event.is_action_pressed("ball_release"): # space was pressed while the ball is being held
		# removed the held flag to let the ball start moving
		held = false
		# turn on particle trail
		trail.set_emitting(true)


func _on_visible_exit_screen():
	# free the ball resources
	queue_free()

