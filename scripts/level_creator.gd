extends Node2D

const CAMERA_VELOCITY = 20

@onready var enemies = $Enemies
@onready var door = $Door
@onready var level_music = $level_music

@export var next_level: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	enemies.area_cleared.connect(door.open_door)
	if self.name == "Tutorial":
		Game.player.cutscene_finished.connect(play_level_music)
	else:
		await get_tree().create_timer(1).timeout
		play_level_music()

func _on_cutscene_area_body_entered(body):
	if body is Player:
		Game.player.door_cutscene()

func play_level_music():
	if not level_music.stream:
		printerr("No file attached to level_music.")
		return
	level_music.play()

func _on_level_music_finished():
	await get_tree().create_timer(1).timeout
	play_level_music()
