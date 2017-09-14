extends Node


onready var block_container = get_node("BlockContainer")
onready var ball_container = get_node("BallContainer")
onready var hud = get_node("Hud")

var ball_scene = preload("res://objects/Ball.tscn")
var block_scene = preload("res://objects/Block.tscn")


func _ready():
	set_fixed_process(true)
	
	create_ball()
	create_blocks()


func _fixed_process(delta):
	if block_container.get_child_count() == 0:
		reset_balls()
		create_blocks()


func _on_ball_destroyed():
	if ball_container.get_child_count() > 1:
		return
	
	hud.lives -= 1
	if hud.lives == 0:
		print("game over")
	else:
		create_ball()


func _on_block_destroyed():
	hud.score += 10


func reset_balls():
	while ball_container.get_child_count() > 1:
		var ball = ball_container.get_child(0)
		ball_container.remove_child(ball)
		ball.queue_free()
	
	var ball = ball_container.get_child(0)
	ball.held = true
	ball.hold_position = get_node("Paddle/BallHolder")


func create_ball():
	var ball = ball_scene.instance()
	ball.hold_position = get_node("Paddle/BallHolder")
	ball.connect("destroyed", self, "_on_ball_destroyed")
	ball_container.add_child(ball)


func create_blocks():
	randomize()
	var r = rand_range(0, 1)
	var g = rand_range(0, 1)
	var b = rand_range(0, 1)
	var base_color = Color(r, g, b, 1)
	
	var wall_color = base_color.inverted()
	get_node("Walls/Left").set_modulate(wall_color)
	get_node("Walls/Right").set_modulate(wall_color)
	get_node("Walls/Top").set_modulate(wall_color)
	
	var startingX = 64
	var incrementX = 64
	for row in range(1, 6):
		var row_color = base_color
		row_color.v = .3 + (.15 * row)
		for column in range(1, 16):
			var position = Vector2(64 * column, 320 - (32 * row))
			var block = block_scene.instance()
			block.set_pos(position)
			block.get_node("Sprite").set_modulate(row_color)
			block.connect("destroyed", self, "_on_block_destroyed")
			block_container.add_child(block)

