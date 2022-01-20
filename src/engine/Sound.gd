extends Node

func play(sound: String, db, pitch, coords=null):
	var sound_player
	if coords:
		sound_player = AudioStreamPlayer2D.new()
		sound_player.global_position = coords
	else:
		sound_player = AudioStreamPlayer.new()
	add_child(sound_player)
	sound_player.connect("finished", sound_player, "queue_free")
	sound_player.stream = load(sound)
	sound_player.volume_db = db
	sound_player.pitch_scale = pitch
	sound_player.play()


func play_after_time(sound: String, db, pitch, time):
	var timer := Timer.new()
	timer.wait_time = time
	add_child(timer)
	timer.connect("timeout", self, "play", [sound, db, pitch])
	timer.connect("timeout", timer, "queue_free")
	timer.start()
