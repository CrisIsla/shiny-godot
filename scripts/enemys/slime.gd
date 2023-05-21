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

func _on_damage_area_entered(area):
	if area.is_in_group("player_hit"):
		if is_killable:
			_die(turn_pivot)
		else:
			_on_hit_turn(turn_pivot, 6, 8)
#		
