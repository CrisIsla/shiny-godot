extends CanvasLayer

@onready var animation_player = $AnimationPlayer

signal started
signal finished

func fade_in():
	emit_signal("started")
	animation_player.play("fade_in")
	await animation_player.animation_finished

func fade_out():
	animation_player.play("fade_out")
	await animation_player.animation_finished
	emit_signal("finished")
