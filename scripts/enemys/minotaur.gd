extends Enemy

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var pivot = $Pivot
@onready var wall_raycast = $Pivot/Wall
@onready var floor_raycast = $Pivot/Floor
@onready var timer = $Timer

var lives = 2
var direction = 1
var can_attack = true

const ACCELERATION = 100
const ON_HIT_KNOCKBACK = 500

enum {
	IDLE, MOVING, CHASING, ATTACKING
}

var state = MOVING
var states = [IDLE, MOVING, ATTACKING]
var attacks = ["attack1", "attack2", "special_attack"]


func _input(event):
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()

func _ready():
	turn_pivot = $Pivot/TurnPivot
	randomize()
	animation_tree.active = true

func _physics_process(delta):
	update_is_killable(turn_pivot)
	if not is_on_floor():
		apply_gravity(delta)
	match state:
		IDLE:
			playback.travel("idle")
			velocity.x = move_toward(velocity.x, 0, ACCELERATION)
			
		MOVING:
			if wall_raycast.is_colliding() or not floor_raycast.is_colliding():
				direction *= -1
				pivot.scale.x = direction
			playback.travel("run")
			velocity.x = move_toward(velocity.x, speed * direction, ACCELERATION)
			
		ATTACKING:
			attack()
			
		CHASING:
			follow_player()
			playback.travel("run")
			if _distance_to_player() < 30:
				attack()
				
		
	move_and_slide()

func attack():
	if not can_attack:
		return
	velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	var current_attack = choose(attacks)
	playback.travel(current_attack)
	can_attack = false
	timer.start()

func choose(array: Array):
	array.shuffle()
	return array[0]
	
func follow_player():
	var player_xpos = Game.player.global_position.x
	direction = sign(player_xpos - self.global_position.x)
	pivot.scale.x = direction
	velocity.x = move_toward(velocity.x, player_xpos - self.global_position.x, ACCELERATION)

func _on_chasing_body_entered(body):
	if body.is_in_group("player"):
		state = CHASING

func _on_chasing_body_exited(body):
	if body.is_in_group("player"):
		state = choose(states)

func take_hit():
	if lives > 0:
		lives -= 1
		_on_hit_turn(turn_pivot, 2, 1)
		return
	if is_killable:
		_die(turn_pivot)
	else:
		_on_hit_turn(turn_pivot, 6, 8)
	

func _on_special_attack_area_entered(area):
	var player = area.get_parent() as Player
	player.take_damage(damage)

func _on_attack_2_area_entered(area):
	var player = area.get_parent() as Player
	player.take_damage(damage)

func _on_attack_1_area_entered(area):
	var player = area.get_parent() as Player
	player.take_damage(damage)

func _on_hitbox_area_entered(area):
	var player = area.get_parent() as Player
	player.take_damage(damage)
	player.knockback(ON_HIT_KNOCKBACK, global_position)

func _distance_to_player():
	var player_pos = Game.player.global_position.x
	return abs(player_pos - global_position.x)



func _on_timer_timeout():
	can_attack = true
