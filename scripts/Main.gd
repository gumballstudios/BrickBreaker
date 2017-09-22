extends Node


onready var block_container = get_node("BlockContainer")
onready var ball_container = get_node("BallContainer")
onready var hud = get_node("Hud")

var ball_scene = preload("res://objects/Ball.tscn")
var block_scene = preload("res://objects/Block.tscn")


func _ready():
	# turn on fixed step processing
	set_fixed_process(true)
	
	# initialize the score
	hud.score = 0
	# initialize the number of lives
	hud.lives = 3
	
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
	# get the block factory
	var factory = get_node("BlockFactory")
	# have the factory generate a set of blocks for the level
	var block_list = factory.generate_blocks()
	# loop through each block in the list
	for block in block_list:
		# connect the block's destroyed signal to the handler method
		block.connect("destroyed", self, "_on_block_destroyed")
		# add the block node to the container
		block_container.add_child(block)


func _on_block_destroyed(block):
	hud.score += block.score_value


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

