extends Node2D

# Called when the node enters the scene tree for the first time.


func _input(event):
	if event.is_action_pressed("spawn_bullet"):
		var bullet_resource = preload("res://scenes/bullet.tscn")
		var bullet = bullet_resource.instantiate()
		bullet.position = Vector2(865, 18)
		add_child(bullet)
