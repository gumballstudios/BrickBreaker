extends Particles2D


func _ready():
	# start emitting particles
	set_emitting(true)
	
	# get the "destoyer" node
	var destroyer = get_node("Destroyer")
	# have the destroyer free this node's resources after the emitter is finished
	destroyer.interpolate_callback(self, get_emit_timeout() + 0.01, "queue_free")
	# start the destroyer
	destroyer.start()

