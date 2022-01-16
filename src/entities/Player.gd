extends KinematicBody2D

var accel = 1
export var move_speed := 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	var motion = Vector2()
	
	if Input.is_action_pressed("move_up"):
		motion.y -= accel
	if Input.is_action_pressed("move_down"):
		motion.y += accel
	if Input.is_action_pressed("move_left"):
		motion.x -= accel
	if Input.is_action_pressed("move_right"):
		motion.x += accel
	
	motion = motion.normalized()
	motion = move_and_slide(motion * move_speed)
	
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("interact"):
		var col = $Interact.get_collider()
		if col && "Door" in col.get_owner().name:
			print(col.get_owner())
			col.get_owner().get_node("AnimationPlayer").play("open_wide")
