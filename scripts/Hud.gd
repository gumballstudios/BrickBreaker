extends Control


export var score = 0
export var lives = 3

var ball_sprite = preload("res://sprites/ball.png")


func _ready():
	set_process(true)


func _process(delta):
	var score_text = get_node("ScoreContainer/Score")
	score_text.set_text(str(score))
	
	var lives_container = get_node("LivesContainer")
	var display_lives = lives - 1
	if display_lives < 0:
		return
	
	if lives_container.get_child_count() != display_lives:
		while lives_container.get_child_count() > display_lives:
			var life_icon = lives_container.get_child(0)
			lives_container.remove_child(life_icon)
			life_icon.queue_free()
		
		while lives_container.get_child_count() < display_lives:
			var life_icon = TextureFrame.new()
			life_icon.set_texture(ball_sprite)
			lives_container.add_child(life_icon)