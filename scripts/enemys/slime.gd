extends "res://scripts/enemy.gd"

@onready var animation_player = $AnimationPlayer
@onready var hurtbox = $CollisionShape2D
@onready var pivot = $Pivot
@onready var turn_pivot = $Pivot/TurnPivot
@onready var wall_raycast = $Pivot/Wall
@onready var floor_raycast = $Pivot/Floor

@export var can_move: bool = false
var direction = 1

const ON_HIT_KNOCKBACK = 300

func _ready():
	animation_player.play("idle")
	hurtbox.disabled = false
	is_killable = 0

func _physics_process(delta):
	update_is_killable(turn_pivot)
	if not is_on_floor():
		apply_gravity(delta)
	if can_move:
		move()
	move_and_slide()


func _on_hitbox_area_entered(area):
	if area.is_in_group("player_hurtbox"):
		var player = area.get_parent() as Player
		player.take_damage(damage)
		player.knockback(ON_HIT_KNOCKBACK, global_position)

func move():
	velocity.x = speed * direction
	if not floor_raycast.is_colliding() or wall_raycast.is_colliding():
		pivot.scale.x *= -1
		direction *= -1
		


func _on_hurtbox_area_entered(area):
	if is_killable:
		_die(turn_pivot)
	else:
		_on_hit_turn(turn_pivot, 6, 8)
