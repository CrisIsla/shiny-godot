extends CharacterBody2D
class_name Enemy

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var is_turning = false

@export var speed: int
@export var jump_velocity: int
@export var hp: int
@export var damage: int
@export var is_killable: bool = false

var turn_pivot: Node2D

func _physics_process(delta):
	if not is_on_floor():
		apply_gravity(delta)
	
	move_and_slide()

func apply_gravity(delta):
	velocity.y += gravity * delta
	
func _die(turn_pivot: Node2D):
	var radians = turn_pivot.skew
	while radians < -2*PI:
		radians += 2*PI

	var target_radians
	if radians > -PI:
		target_radians = (-PI/2 - radians) + turn_pivot.skew
	else:
		target_radians = -6*PI/4 - radians + turn_pivot.skew
		
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(turn_pivot, "skew", target_radians, 0.2)
	tween.tween_callback(self.queue_free)

func _exit_tree():
	get_parent().on_enemy_died()
	
func _on_hit_turn(turn_pivot: Node2D, half_turns: int, turn_time: float):
	if is_turning:
		return
	is_turning = true
	
	turn_pivot.skew = 0
	is_killable = 1
	
	# rotate
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(turn_pivot, "skew", - half_turns * PI, turn_time)
	tween.tween_property(self, "is_turning", false, 0)

func update_is_killable(turn_pivot: Node2D):
	var radians = turn_pivot.skew
	while radians < -2*PI:
		radians += 2*PI
	radians *= -1
	var dead_zone = 0.3
	if (radians < PI/2 + dead_zone and radians > PI/2 - dead_zone) or (radians < 6*PI/4 + dead_zone and radians > 6*PI/4 - dead_zone):
		is_killable = 1
	else:
		is_killable = 0

func _set_is_killable(value):
	is_killable = value

func take_hit():
	print("take_hit")
	if is_killable:
		_die(turn_pivot)
	else:
		_on_hit_turn(turn_pivot, 6, 8)


	
	
	
	
	
