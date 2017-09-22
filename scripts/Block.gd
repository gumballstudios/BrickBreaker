extends StaticBody2D


signal destroyed(block)

var explosion_scene = preload("res://objects/BlockExplosion.tscn")

var score_value = 5


func _ready():
	pass


func hit():
	# let everyone know we've been destroyed
	emit_signal("destroyed", self)
	
	# get the sprite node
	var sprite = get_node("Sprite")
	# get the color of the sprite
	var color = sprite.get_modulate()
	
	# create a new node from the explosion scene
	var explosion = explosion_scene.instance()
	# set the explosion's position to the block's position
	explosion.set_pos(get_global_pos())
	# set the color to the same color as the sprite
	explosion.set_color(color)
	# add the explosion to the block container
	get_parent().add_child(explosion)
	
	# free the node's resources
	queue_free()

