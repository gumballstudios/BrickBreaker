extends KinematicBody2D


signal destroyed

const BALL_SPEED = 300
const PADDLE_INFLUENCE = 350

var velocity = Vector2()
var held = true
var hold_position


func _ready():
	set_fixed_process(true)
	set_process_input(true)
	
	randomize()
	var angle = rand_range(-30, 30)
	velocity = Vector2(0, -BALL_SPEED).rotated(deg2rad(angle))


func _fixed_process(delta):
	if held:
		set_pos(hold_position.get_global_pos())
		return
	
	# move the ball
	var motion = move(velocity * delta)
	
	if is_colliding(): # something was hit
		# determine normal and reflect
		var normal = get_collision_normal()
		motion = normal.reflect(motion)
		velocity = normal.reflect(velocity)
		
		# check what was hit
		var body = get_collider()
		if body.is_in_group("Blocks"): # hit a block
			# Let the block know it was hit
			body.hit() 
		elif body.get_name() == "Paddle": # hit the paddle
			# check distance from center of paddle
			var direction = get_pos() - body.get_global_pos()
			# adjust the angle of the ball
			velocity += (direction / 48) * PADDLE_INFLUENCE
			# reset the ball speed
			velocity = velocity.normalized() * BALL_SPEED
		
		# move the remaining reflected distance
		#move(motion)


func _input(event):
	if held and event.is_action_pressed("ball_release"):
		held = false


func _on_visible_exit_screen():
	emit_signal("destroyed")
	queue_free()

