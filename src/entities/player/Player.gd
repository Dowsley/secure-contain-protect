extends Entity
class_name Player

# Internals
var interact_cooldown := 20

# Nodes
onready var interact_ray = $InteractRay
onready var body_sprite = $BodySprite

var gun = preload("res://src/entities/player/guns/AssaultRifle.tscn").instance()

# ------------- INTERNALS -------------
func _ready():
	if !TYPE:
		TYPE = TYPES.PLAYER


func _physics_process(_delta):
	match state:
		STATES.DEFAULT:
			state_default()
		STATES.ATTACK:
			state_attack()
	
	if interact_cooldown > 0:
		interact_cooldown -= 1


# ------------- STATES -------------
func state_default():
	loop_controls()
	loop_movement()
	loop_interact()
	
	if move_dir == Vector2.ZERO:
		anim_switch("idle")
	else:
		anim_switch("move")



func state_attack():
	loop_controls()
	loop_movement()
	loop_attack()


# ------------- LOOPS -------------
func loop_attack():
	randomize()
	var sound = "res://assets/bullet%d.mp3" % (randi() % 3 + 1)
	
	gun.fire(self)
	anim_switch("shoot")
	$GunAnimationPlayer.play("shoot")
	SFX.play("res://assets/gunshot.wav", 10, 0.8)
	SFX.play_after_time(sound, 0.5)


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
	
	if Input.is_action_just_pressed("primary_action"):
		state = STATES.ATTACK
	else:
		state = STATES.DEFAULT

func loop_interact():
	if Input.is_action_just_pressed("interact") && interact_ray.is_colliding():
		var object = interact_ray.get_collider().get_owner()
		if interact_cooldown == 0 && object.is_in_group("interact"):
			object.interact(self) # Pass the player as argument


# ------------- ESSENTIALS -------------
func anim_switch(anim_name, speed_scale=1):
	body_sprite.speed_scale = speed_scale
	body_sprite.play(anim_name)
