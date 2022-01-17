extends Entity
class_name Player

# Internals
var action_cooldown := 0
export var COOLDOWN_TIME := 20

# Nodes
onready var interact_ray = $InteractRay
onready var body_sprite = $BodySprite


# ------------- INTERNALS -------------
func _ready():
	if !TYPE:
		TYPE = TYPES.PLAYER


func _physics_process(_delta):
	match state:
		STATES.DEFAULT:
			state_default()
	
	if action_cooldown > 0:
		action_cooldown -= 1


# ------------- STATES -------------
func state_default():
	loop_controls()
	loop_movement()
	loop_interact()
	
	if move_dir == Vector2.ZERO:
		anim_switch("idle")
	else:
		anim_switch("move")


# ------------- LOOPS -------------
func loop_controls():
	# Keyboard
	move_dir = Vector2.ZERO
	var LEFT = Input.is_action_pressed("move_left")
	var RIGHT = Input.is_action_pressed("move_right")
	var UP = Input.is_action_pressed("move_up")
	var DOWN = Input.is_action_pressed("move_down")
	
	move_dir.x = -int(LEFT) + int(RIGHT)
	move_dir.y = -int(UP) + int(DOWN)
	
	# Mouse
	look_at(get_global_mouse_position())


func loop_interact():
	if Input.is_action_just_pressed("interact") && interact_ray.is_colliding():
		var object = interact_ray.get_collider().get_owner()
		if action_cooldown == 0 && object.is_in_group("interact"):
			object.interact(self) # Pass the player as argument


# ------------- ESSENTIALS -------------
func anim_switch(anim_name):
	body_sprite.play(anim_name)
