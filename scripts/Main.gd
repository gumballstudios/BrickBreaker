extends Node


onready var block_container = get_node("BlockContainer")
onready var ball_container = get_node("BallContainer")
onready var hud = get_node("Hud")
onready var sound_effects = get_node("SoundEffects")

var ball_scene = preload("res://objects/Ball.tscn")
var block_scene = preload("res://objects/Block.tscn")

var block_count = 0


func _ready():
	# initialize the score
	hud.score = 0
	# initialize the number of lives
	hud.lives = 3
	
	# setup a new ball node
	create_ball()
	# setup the block nodes
	create_blocks()


func create_blocks():
	# get the block factory
	var factory = get_node("BlockFactory")
	# have the factory generate a set of blocks for the level
	var block_list = factory.generate_blocks()
	# store the number of blocks in this round
	block_count = block_list.size()
	# loop through each block in the list
	for block in block_list:
		# connect the block's destroyed signal to the handler method
		block.connect("destroyed", self, "_on_block_destroyed")
		# add the block node to the container
		block_container.add_child(block)


func _on_block_destroyed(block):
	# update the score based on the block's score value
	hud.score += block.score_value
	# decrement the count of blocks
	block_count -= 1
	if block_count == 0: # no blocks left
		# play the round end sound
		sound_effects.play_sound("RoundEnd")
		# remove any ball nodes
		remove_balls()
		# wait until the sound is finished playing
		yield(sound_effects, "finished")
		# setup a new ball node
		create_ball()
		# setup the block nodes
		create_blocks()


func create_ball():
	# create a new node from the ball scene
	var ball = ball_scene.instance()
	# get the paddle's Position2D node
	var hold_position = get_node("Paddle/BallHolder")
	# initialize the ball
	ball.initialize(hold_position)
	# connect the ball's destroyed signal to the handler method
	ball.connect("destroyed", self, "_on_ball_destroyed")
	# add the ball to the container
	ball_container.add_child(ball)


func respawn_ball():
	# decrement lives by 1
	hud.lives -= 1
	# play the ball lost sound
	sound_effects.play_sound("BallLost")
	# wait until the sound is finished playing
	yield(sound_effects, "finished")
	if hud.lives <= 0: # no more lives
		print("game over")
	else: # keep playing
		# setup a new ball node
		create_ball()


func remove_balls():
	# check for more than one ball node in the container
	for ball in  ball_container.get_children():
		# free the node resources
		ball.queue_free()


func _on_ball_destroyed():
	respawn_ball()
