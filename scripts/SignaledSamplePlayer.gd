extends SamplePlayer


signal finished

var playing = false


func _ready():
	# turn on step processing
	set_process(true);


func play_sound(key):
	# play the requested sound
	play(key);
	# enable the flag
	playing = true;


func _process(delta):
	if(!is_active() && playing): # sound has stopped playing but the flag is on
		# let everyone know the sound has stopped
		emit_signal("finished");
		# disable the flag
		playing = false;
