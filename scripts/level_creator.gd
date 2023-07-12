extends Node2D

const CAMERA_VELOCITY = 20

@onready var enemies = $Enemies
@onready var door = $Door

@export var next_level: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	enemies.area_cleared.connect(door.open_door)


func _on_cutscene_area_body_entered(body):
	if body is Player:
		Game.player.door_cutscene()
