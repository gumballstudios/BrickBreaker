extends Control


var score setget set_score
var lives setget set_lives

var ball_sprite = preload("res://sprites/ball.png")


func _ready():
	pass


func set_score(value):
	# update score 
	score = value
	
	# get the score node
	var score_text = get_node("ScoreContainer/Score")
	# update the node's text with the new score
	score_text.set_text(str(score))


func set_lives(value):
	# update lives
	lives = value
	
	# calculate remaining lives to display
	# display lives should never go below 0
	var display_lives = max(lives - 1, 0)
	
	# get the container node for lives display
	var lives_container = get_node("LivesContainer")
	
	# remove any life icons over the amount to be displayed
	while lives_container.get_child_count() > display_lives:
		# get the first node in the container
		var life_icon = lives_container.get_child(0)
		# remove the node from the container
		lives_container.remove_child(life_icon)
		# free the node resources
		life_icon.queue_free()
	
	# add any life icons to match the amount to be displayed
	while lives_container.get_child_count() < display_lives:
		# create a new texture frame node
		var life_icon = TextureFrame.new()
		# set the texture to the ball sprite
		life_icon.set_texture(ball_sprite)
		# add the node to the container
		lives_container.add_child(life_icon)
		# HBoxContainer will handle spacing the nodes in the container

