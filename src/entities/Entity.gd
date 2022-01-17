extends KinematicBody2D
class_name Entity

# ATTRIBUTES
enum TYPES {
	PLAYER,
	ENEMY
}
export(TYPES) var TYPE := TYPES.ENEMY

# STATS
export(int) var SPEED := 70

# MOVEMENT
enum SPRITE_DIRS {
	UP,
	DOWN,
	LEFT,
	RIGHT
}
var move_dir := Vector2.ZERO
var last_dir := Vector2.RIGHT 
var sprite_dir: int = SPRITE_DIRS.DOWN

# STATE
enum STATES {
	DEFAULT
}
var state: int = STATES.DEFAULT


# ------------- INTERNALS -------------
func _ready():
	add_to_group("entity")


# ------------- LOOPS -------------
func loop_movement():
	last_dir = move_dir
	var motion := move_dir.normalized() * SPEED
	var _linear_velocity := move_and_slide(motion)
