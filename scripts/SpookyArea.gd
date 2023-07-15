extends Area2D

@onready var spooky_music = $"../spooky_music"
var level
# Called when the node enters the scene tree for the first time.
func _ready():
	level = get_parent()

func _on_body_entered(body):
	if body is Player:
		level.level_music.stop()
		spooky_music.play()
