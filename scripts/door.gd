extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var finish_line = $finish_line

var is_opened = false
var level

func _ready():
	finish_line.monitoring = false
	level = get_parent()

func open_door():
	is_opened = true
	animation_player.play("door_opening")
	finish_line.monitoring = true

func _on_finish_line_body_entered(body):
	if body is Player and level.next_level != null:
		get_tree().change_scene_to_packed(level.next_level)
