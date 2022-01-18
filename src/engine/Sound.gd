extends Node


func play(sound: String, db, pitch):
	var player := AudioStreamPlayer.new()
	add_child(player)
	player.connect("finished", player, "queue_free")
	player.stream = load(sound)
	player.volume_db = db
	player.pitch_scale = pitch
	player.play()


func play_after_time(sound: String, db, pitch, time):
	var timer := Timer.new()
	timer.wait_time = time
	add_child(timer)
	timer.connect("timeout", self, "play", [sound, db, pitch])
	timer.connect("timeout", timer, "queue_free")
	timer.start()
