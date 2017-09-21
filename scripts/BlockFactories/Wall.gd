extends Node


var block_scene = preload("res://objects/Block.tscn")


func _ready():
	# randomize the randon generator seed
	randomize()


func generate_blocks():
	# create a new array to hold the block nodes
	var block_list = []
	
	# get the starting position of the wall of blocks
	var origin = get_node("Start").get_pos()
	
		# get a random base color for the blocks
	var base_color = random_color()
	
	# create the rows and columns of blocks, left to right and top to bottom from origin
	# loop through 5 rows
	for row in range(0, 5):
		# copy the base color
		var row_color = base_color
		# adjust the value/brightness based on row height
		row_color.v = 1 - (.15 * row)
		# calculate the row's y position
		var y = origin.y + (40 * row)
		
		# loop through 15 columns in the row
		for column in range(0, 15):
			# calculate the column x position
			var x = origin.x + (80 * column)
			# create the row/column position
			var position = Vector2(x, y)
			# create a new node from the block scene
			var block = block_scene.instance()
			# set the block's position to it's row/column
			block.set_pos(position)
			# adjust the block's sprite color to the row's color
			block.get_node("Sprite").set_modulate(row_color)
			# add the block node to the list
			block_list.append(block)
	
	# return the list of block nodes
	return block_list


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

