extends PanelContainer

func _ready():
	hide()
	
func _input(event):
	if event.is_action_pressed("exit"):
		self.visible = !self.visible
		get_tree().paused = !get_tree().paused

func _on_resume_button_up():
	get_tree().paused = false
	hide()

func _on_retry_button_up():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_main_menu_button_up():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_exit_button_up():
	get_tree().quit()
