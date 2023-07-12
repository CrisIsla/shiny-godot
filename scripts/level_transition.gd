extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func fade_in():
	animation_player.play("fade_in")
	await animation_player.animation_finished
	Game.player.can_move = true

func fade_out():
	Game.player.can_move = false
	animation_player.play("fade_out")
	await animation_player.animation_finished
