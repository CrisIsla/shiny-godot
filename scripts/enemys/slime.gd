extends "res://scripts/enemy.gd"

@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	animation_player.play("idle")
	collision_shape_2d.disabled = false

func _on_damage_area_entered(area):
	if area.is_in_group("player_hit"):
		if hp <= 0:
			animation_player.play("death")
			await animation_player.animation_finished
			queue_free()
		animation_player.play("hurt", -1, 1.5)
		await animation_player.animation_finished
		animation_player.play("idle")
		
func _on_hitbox_area_entered(area):
	if area.is_in_group("player_hurtbox"):
		var player = area.get_parent() as Player
		player.take_damage(damage)
		print(player.hp)
