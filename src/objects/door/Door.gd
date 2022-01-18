extends Node2D
class_name Door

# States
enum STATES {
	OPEN_FRONT,
	OPEN_BACK,
	CLOSED,
}
export(STATES) var state := STATES.CLOSED

# Nodes
onready var tween := $Tween
onready var front_ray := $FrontRay
onready var rotation_point := $RotationPoint


# ------------- INTERNALS -------------
func _ready():
	match state:
		STATES.OPEN_FRONT:
			rotation_point.rotation_degrees = 80
		STATES.OPEN_BACK:
			rotation_point.rotation_degrees = -80
		STATES.CLOSED:
			rotation_point.rotation_degrees = 0


# ------------- ESSENTIALS -------------
func interact(player):
	match state:
		STATES.CLOSED:
			open()
		STATES.OPEN_FRONT:
			close()
		STATES.OPEN_BACK:
			close()
	player.interact_cooldown = 20
	tween.start()


func open():
	# Get which direction to open based on player detection
	var to_front: bool = not (front_ray.is_colliding() && "Player" == front_ray.get_collider().name)
	
	var from := 0
	if tween.is_active():
		tween.stop(rotation_point, "rotation_degrees")
		from = rotation_point.rotation_degrees
	
	tween.interpolate_property(
		rotation_point,
		"rotation_degrees",
		from, 
		80 if to_front else -80,
		1,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	
	state = STATES.OPEN_FRONT if to_front else STATES.OPEN_BACK


func close():
	var from: int = 80 if state == STATES.OPEN_FRONT else -80
	if tween.is_active():
		tween.stop(rotation_point, "rotation_degrees")
		from = rotation_point.rotation_degrees
	tween.interpolate_property(
		rotation_point,
		"rotation_degrees",
		from, 
		0,
		1,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	
	state = STATES.CLOSED

