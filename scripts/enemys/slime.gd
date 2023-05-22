extends "res://scripts/enemy.gd"

@onready var animation_player = $AnimationPlayer
@onready var hurtbox = $CollisionShape2D
@onready var pivot = $TurnPivot/Pivot
@onready var turn_pivot = $TurnPivot

func _ready():
	animation_player.play("idle")
	hurtbox.disabled = false
	is_killable = 0

func _physics_process(delta):
	update_is_killable(turn_pivot)
	if not is_on_floor():
		apply_gravity(delta)
	move_and_slide()

func _on_damage_area_entered(area):
	if area.is_in_group("player_hit"):
		if is_killable:
			_die(turn_pivot)
		else:
			_on_hit_turn(turn_pivot, 6, 8)
		
func _on_hitbox_area_entered(area):
	if area.is_in_group("player_hurtbox"):
		var player = area.get_parent() as Player
		player.take_damage(damage)
		print(player.hp)
