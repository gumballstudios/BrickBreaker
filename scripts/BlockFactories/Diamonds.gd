extends Node


var block_scene = preload("res://objects/Block.tscn")

var block_offset = Vector2(80, 40)
# define the directions a quadrant goes from the start; left or right and up or down
var quad_directions = [
	Vector2(-1, -1), 
	Vector2(1, -1), 
	Vector2(1, 1), 
	Vector2(-1, 1)
]
# define the rows in a quadrant in number of block from the start
var quad_positions = [
	[
		Vector2(0, 0)
	],
	[
		Vector2(1, 0),
		Vector2(0, 1)
	],
	[
		Vector2(2, 0),
		Vector2(1, 1),
		Vector2(0, 2)
	]
]
var row_count = quad_positions.size()
var base_score_value = 10
var base_speed_level = 4


func _ready():
	pass


func generate_blocks():
	# create a new array to hold the block nodes
	var block_list = []
	
	# get a random base color for the blocks
	var base_color = random_color()
	
	# loop through each of the diamon patterns in the factory
	for diamond in get_children():
		# reset the index for the quad_directions array
		var origin_index = 0
		# loop through each quadrant starting position in the diamond
		for origin in diamond.get_children():
			# reset the row index
			var row_index = 0
			# loop through each row in the quadrant
			for row in quad_positions:
				# copy the base color
				var row_color = base_color
				# adjust the value/brightness based on row index
				row_color.v = 1 - (.3 * row_index)
				# loop through the positions in a row
				for position_offset in row:
					# calculate the actual position from the starting position using 
					# block size (block_offset), number of blocks to offset (position_offset) and direction (quad_directions)
					var position = origin.get_pos() + (block_offset * position_offset * quad_directions[origin_index])
					
					# create a new node from the block scene
					var block = block_scene.instance()
					# set the block's position
					block.set_pos(position)
					# adjust the block's sprite color to the row's color
					block.get_node("Sprite").set_modulate(row_color)
					# set the block's score value
					block.score_value = base_score_value * (row_count - row_index)
					# set the block's speed_level
					block.speed_level = base_speed_level - (2 * row_index)
					# add the block node to the list
					block_list.append(block)
				# end for position_offset
				
				# increment the row index
				row_index += 1
			# end for row
			
			# increment the origin index
			origin_index += 1
		# end for origin 
	# end for diamond
	
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

