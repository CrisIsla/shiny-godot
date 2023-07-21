extends Control

@onready var animation_player = $AnimationPlayer
@onready var fade = $fade/fade

func _input(event):
	if event.is_action_pressed("exit"):
		go_to_menu()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "credits":
		go_to_menu()
		
func go_to_menu():
	fade.play("fade")
	await fade.animation_finished
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
