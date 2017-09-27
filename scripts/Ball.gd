extends KinematicBody2D


const BALL_SPEED = 300
const PADDLE_INFLUENCE = 5
const MAX_SPEED_LEVEL = 5


var velocity = Vector2()
var speed_level = 0
var speed_increase_percentage = 0.05

var held = true
var hold_position


onready var sound_effects = get_node("SoundEffects")
onready var trail = get_node("Trail")

var collision_scene = preload("res://objects/BallCollision.tscn")


func _ready():
	# turn on fixed step processing
	set_fixed_process(true)
	# turn on input handling
	set_process_input(true)


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
	# move the ball and get any remaining motion after a collision
	var remaining_motion = move(motion)
	
	if is_colliding(): # something was hit
		# determine normal of the body struck
		var normal = get_collision_normal()
		# reflect the velocity using that normal
		velocity = normal.reflect(velocity)
		# reflect the remaining motion using that normal
		remaining_motion = normal.reflect(remaining_motion)
		
		# create a new node from the ball collision scene
		var collision = collision_scene.instance()
		# set the effect's position
		collision.set_pos(determine_effect_position())
		# get the root
		var root = get_node("/root")
		# get the main scene (last child of the root)
		var main_scene = root.get_child(root.get_child_count() - 1)
		# add the node to the main scene
		main_scene.add_child(collision)
		
		# check what was hit
		var body = get_collider()
		if body.is_in_group("Blocks"): # hit a block
			# Let the block know it was hit and see if it was destroyed
			var block_destroyed = body.hit() 
			if block_destroyed:
				# update the speed level based on the block's speed level
				set_speed_level(body.speed_level)
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
			velocity = velocity.normalized() * get_current_speed()
			# play the paddle hit sound
			sound_effects.play("PaddleHit")
		else:
			if body.get_name() == "Top":
				set_speed_level(MAX_SPEED_LEVEL)
			# play the wall hit sound
			sound_effects.play("WallHit")
		
		# move the remaining motion
		move(remaining_motion)


func _input(event):
	if held and event.is_action_pressed("ball_release"): # space was pressed while the ball is being held
		# removed the held flag to let the ball start moving
		held = false
		# turn on particle trail
		trail.set_emitting(true)


func _on_visible_exit_screen():
	# free the ball resources
	queue_free()


func initialize(new_hold_position):
	# randomize the randon generator seed
	randomize()
	
	# set the ball to being held in one place
	held = true
	# set the position the bass should be held
	hold_position = new_hold_position
	# set the ball's position to the hold position
	set_pos(hold_position.get_pos())
	# set the speed level to the lowest value
	speed_level = 0
	# set the initial velocity going straight upwards
	var initial_velocity = Vector2(0, -1) * get_current_speed()
	# generate a random angle between -30 degrees and 30 degrees
	var angle = rand_range(-30, 30)
	# convert the angle to radians
	var radian = deg2rad(angle)
	# rotate the initial velocity by the random angle
	velocity = initial_velocity.rotated(radian)


func determine_effect_position():
	# get the sprite node
	var sprite = get_node("Sprite")
	# get the diameter (half width) of the sprite
	var sprite_diameter = sprite.get_texture().get_width() / 2
	
	# get the difference between the collision position and the ball's position
	var distance = get_collision_pos() - get_pos();
	# determine the offset based on the collision position being a corner of the collision shape
	#     x,  y = collision on bottom of ball
	#    -x, -y = collision on top of ball
	#    -x,  y = collision on left of ball
	#     x, -y = collision on right of ball
	# create the x offset from the ball's position
	var offset_x = 0 if sign(distance.x) == sign(distance.y) else sign(distance.x)
	# create the y offset from the ball's position
	var offset_y = sign(distance.y) if sign(distance.x) == sign(distance.y) else 0
	
	# return the ball's position plus the offset
	return get_pos() + (Vector2(offset_x, offset_y) * sprite_diameter)


func set_speed_level(new_level):
	# Set speed level to the highest value between old and new values
	speed_level = max(speed_level, new_level)
	# reset the velocity based on the new speed level
	velocity = velocity.normalized() * get_current_speed()


func get_current_speed():
	# calculated the speed increase based on speed level
	var increase = BALL_SPEED * (speed_increase_percentage * speed_level)
	# return the increased speed
	return BALL_SPEED + increase
