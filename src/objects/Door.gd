tool
extends Node2D

export var invertDir := false setget set_invert_dir

func _ready():
	setup_open_dir()

func set_invert_dir(new_value):
	invertDir = new_value
	setup_open_dir()

func setup_open_dir():
	scale *= Vector2(1, -1)

func fully_open_door():
	pass
