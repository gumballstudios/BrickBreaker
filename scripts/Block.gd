extends StaticBody2D


signal destroyed

func _ready():
	pass


func hit():
	emit_signal("destroyed")
	queue_free()