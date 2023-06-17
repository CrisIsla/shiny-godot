extends MarginContainer
@onready var play = $PanelContainer/MarginContainer/VBoxContainer/Play

func _ready():
	play.grab_focus()

func _on_play_button_up():
	get_tree().change_scene_to_file("res://levels/00tutorial.tscn")

func _on_exit_button_up():
	get_tree().quit()
