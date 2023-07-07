extends Node2D

@onready var enemies = $Enemies
@onready var door = $Door

# Called when the node enters the scene tree for the first time.
func _ready():
	enemies.area_cleared.connect(door.open_door)
