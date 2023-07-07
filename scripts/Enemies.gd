extends Node
signal area_cleared

var enemy_count: int

func _ready():
	enemy_count = get_child_count()

func on_enemy_died():
	enemy_count -= 1
	if enemy_count <= 0:
		emit_signal("area_cleared")
