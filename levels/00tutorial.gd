extends Node2D

#@onready var a_key = $"player/A-key"
#@onready var d_key = $"player/D-key"
@onready var animation_player = $AnimationPlayer
var keys_pressed = false

func _input(event):
	pass
#	if (event.is_action_pressed("move_left") or event.is_action_pressed("move_right")) and not keys_pressed:
#		animation_player.play("disappear")
#		keys_pressed = true
#		print("disappearing...")
#		await animation_player.animation_finished
#		a_key.queue_free()
#		d_key.queue_free()

func _on_timer_timeout():
	if not keys_pressed:
		animation_player.play("ease")
