extends Node


onready var block_container = get_node("BlockContainer")
onready var ball_container = get_node("BallContainer")
onready var hud = get_node("Hud")

var ball_scene = preload("res://objects/Ball.tscn")
var block_scene = preload("res://objects/Block.tscn")


func _ready():
	# turn on fixed step processing
	set_fixed_process(true)
	
	# setup a new ball node
	create_ball()
	# setup the block nodes
	create_blocks()


func _fixed_process(delta):
	if block_container.get_child_count() == 0: # all the blocks are gone
		# reset any ball nodes
		reset_balls()
		# setup the block nodes
		create_blocks()
	
	if ball_container.get_child_count() == 0: # all the balls are gone
		# adjust the lives count and setup a new ball node
		respawn_ball()


func create_blocks():
	# get a random base color for the blocks
	var base_color = random_color()
	
	# invert the base color to use as the wall color
	var wall_color = base_color.inverted()
	# apply the wall color to the wall sprite on the left
	get_node("Walls/Left").set_modulate(wall_color)
	# right
	get_node("Walls/Right").set_modulate(wall_color)
	# and top
	get_node("Walls/Top").set_modulate(wall_color)
	
	# create the rows and columns of blocks, left to right and bottom to top
	# loop through 5 rows
	for row in range(1, 6):
		# copy the base color
		var row_color = base_color
		# adjust the value/brightness based on row height
		row_color.v = .3 + (.15 * row)
		# calculate the row's y position
		var y = 320 - (32 * row)
		
		# loop through 15 columns in the row
		for column in range(1, 16):
			# calculate the column x position
			var x = 64 * column
			# create the row/column position
			var position = Vector2(x, y)
			# create a new node from the block scene
			var block = block_scene.instance()
			# set the block's position to it's row/column
			block.set_pos(position)
			# adjust the block's sprite color to the row's color
			block.get_node("Sprite").set_modulate(row_color)
			# connect the signal to the handler method
			block.connect("destroyed", self, "_on_block_destroyed")
			# add the block node to the container
			block_container.add_child(block)


func _on_block_destroyed():
	hud.score += 10


func create_ball():
	# create a new node from the ball scene
	var ball = ball_scene.instance()
	# get the paddle's Position2D node
	var hold_position = get_node("Paddle/BallHolder")
	# set the ball's hold position to the Position2D node
	ball.hold_position = hold_position
	# set the ball's position to the Position2D node's position
	# this will start the ball in the scene already in the correct location
	ball.set_pos(hold_position.get_pos())
	# add the ball to the container
	ball_container.add_child(ball)


func respawn_ball():
	# decrement lives by 1
	hud.lives -= 1
	if hud.lives <= 0: # no more lives
		print("game over")
	else: # keep playing
		# setup a new ball node
		create_ball()


func reset_balls():
	# check for more than one ball node in the container
	while ball_container.get_child_count() > 1:
		# get the first ball node from the container
		var ball = ball_container.get_child(0)
		# remove the node from the container
		ball_container.remove_child(ball)
		# free the node resources
		ball.queue_free()
	
	# get the single remaining ball node from the container
	var ball = ball_container.get_child(0)
	# enable the held flag
	ball.held = true
	# get the paddle's Position2D node
	var hold_position = get_node("Paddle/BallHolder")
	# set the ball's hold position to the Position2D node
	ball.hold_position = hold_position
	# set the ball's position to the Position2D node's position
	# this will move the ball to the correct location
	ball.set_pos(hold_position.get_pos())


func random_color():
	# randomize the randon generator seed
	randomize()
	
	# get a random value for red
	var r = rand_range(0, 1)
	# green
	var g = rand_range(0, 1)
	# and blue
	var b = rand_range(0, 1)
	
	# return the color using the random rgb values
	return Color(r, g, b)

