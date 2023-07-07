extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var finish_line = $finish_line

var is_opened = false

func _ready():
	finish_line.monitoring = false

func open_door():
	is_opened = true
	animation_player.play("door_opening")
	finish_line.monitoring = true

func _on_finish_line_body_entered(body):
	if body is Player:
		pass
#		go_to_next_level()
