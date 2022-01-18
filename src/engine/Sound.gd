extends Node

func play(sound: String, db=0, pitch=1):
	var player := AudioStreamPlayer.new()
	add_child(player)
	player.connect("finished", player, "queue_free")
	player.stream = load(sound)
	player.volume_db = db
	player.pitch_scale = pitch
	player.play()

func play_after_time(sound: String, time):
	var timer := Timer.new()
	timer.wait_time = time
	add_child(timer)
	timer.connect("timeout", self, "play", [sound, 0, 1])
	timer.connect("timeout", timer, "queue_free")
	timer.start()
