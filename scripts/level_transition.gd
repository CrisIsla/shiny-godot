extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func fade_in():
	animation_player.play("fade_in")
	await animation_player.animation_finished
	if Game.player:
		Game.player.can_move = true # Allow player to move once the animation has finished

func fade_out():
	if Game.player:
		Game.player.can_move = false # Disable player movement to play fade_out transition
	animation_player.play("fade_out")
	await animation_player.animation_finished
