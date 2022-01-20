extends Node2D

onready var overlay := $Overlay
onready var player := $Player

var t

func _ready():
	overlay.visible = false
	player.visible = true
