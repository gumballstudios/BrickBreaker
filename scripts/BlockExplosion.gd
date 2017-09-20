extends Particles2D


func _ready():
	# get the particle fader node
	var fader = get_node("Fader")
	# set the particles to fade out over their lifetime
	fader.interpolate_property(self, "visibility/opacity", 1, 0, get_emit_timeout(), Tween.TRANS_CUBIC, Tween.EASE_IN)
	# star the fader
	fader.start()
	# start emiting particles
	set_emitting(true)


func _on_fader_tween_complete( object, key ):
	queue_free()

