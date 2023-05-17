extends "res://scripts/enemy.gd"

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("idle")
