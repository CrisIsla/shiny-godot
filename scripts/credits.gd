extends Control

func _input(event):
	if event.is_action_pressed("exit"):
		go_to_menu()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "credits":
		go_to_menu()
		
func go_to_menu():
	await LevelTransition.fade_out()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	LevelTransition.fade_in()
