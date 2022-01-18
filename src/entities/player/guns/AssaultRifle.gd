extends Node2D

# Nodes
onready var fire_anim_player = $FireAnimationPlayer 

func fire(player):
	randomize()
	var sound = "res://assets/bullet%d.mp3" % (randi() % 3 + 1)
	
	player.anim_switch("shoot")
	fire_anim_player.play("shoot")
	SoundHandler.play("res://assets/gunshot.wav", 10, 0.8)
	SoundHandler.play_after_time(sound, -5, 1, 0.5)
