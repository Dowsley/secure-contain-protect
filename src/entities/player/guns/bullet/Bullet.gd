extends RayCast2D

# Internals
const MAX_TRAJECTORY = 10000
var marching := true
var no_hit := false

# Nodes
onready var trajectory = $TrajectoryLine
onready var fade_anim = $FadeAnimation
onready var impact_anim = $ImpactSpriteAnimation


# ------------- INTERNALS -------------
func _physics_process(delta):
	if marching == true:
		if not is_colliding() && not get_trajectory_length(cast_to) >= MAX_TRAJECTORY:
			cast_to *= 2
		else:
			marching = false
			if not is_colliding():
				no_hit = true
				draw_trajectory_line(false)
			else:
				draw_trajectory_line(true)
				impact()


# ------------- ESSENTIALS -------------
func start(player):
	add_exception(player)
	enabled = true
	position = player.muzzle.global_position
	cast_to = player.looking_at - position
	player.get_parent().add_child(self)


func impact():
	# TODO: Impact management (ricochet?)
	impact_anim.visible = true
	impact_anim.rotation += get_collision_normal().angle()
	impact_anim.global_position = get_collision_point()
	var anim_name: String
	var sound_name: String
	if (randi() % 10 + 1) == 1: # 1 in 10 chance
		anim_name = "fragmentation"
		sound_name = "res://assets/fragmentation%d.mp3" % (randi() % 3 + 1)
	else:
		anim_name = "impact%d" % (randi() % 2)
		sound_name = "res://assets/impact%d.mp3" % (randi() % 5 + 1)
		# Workaround for sprite offset
		impact_anim.global_position += get_collision_normal() * Vector2(6, 6)
	impact_anim.play(anim_name)
	SoundHandler.play(sound_name, 0, 1, get_collision_point())

func draw_trajectory_line(has_impacted):
	trajectory.add_point(Vector2.ZERO) # Relative to bullet
	trajectory.add_point(get_collision_point() - position if has_impacted else cast_to)
	fade_anim.play("fade_out")


# ------------- UTILS -------------
func get_trajectory_length(t):
	t = sqrt(
		pow(t.x, 2) + pow(t.y, 2)
	)
	return t


# ------------- SIGNAL CALLBACKS -------------
func _on_FadeAnimation_animation_finished(anim_name):
	if no_hit:
		queue_free()


func _on_ImpactSpriteAnimation_animation_finished():
	queue_free()
