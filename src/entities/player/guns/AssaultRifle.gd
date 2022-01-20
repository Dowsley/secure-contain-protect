extends Node2D

# Scenes
var Bullet = preload("res://src/entities/player/guns/bullet/Bullet.tscn")

# Nodes
onready var fire_anim_player = $FireAnimationPlayer 

func shoot(player):
	randomize()
	
	# Muzzle animation & sound
	var sound = "res://assets/bullet%d.mp3" % (randi() % 3 + 1)
	player.anim_switch("shoot")
	fire_anim_player.play("shoot")
	SoundHandler.play("res://assets/gunshot.wav", 10, 0.8)
	SoundHandler.play_after_time(sound, -5, 1, 0.5)

	# Bullet
	var b = Bullet.instance()
	b.start(player)
