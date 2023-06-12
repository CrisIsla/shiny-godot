extends Enemy

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var timer = $Timer
@onready var pivot = $Pivot
@onready var wall = $Pivot/Wall
@onready var floor = $Pivot/Floor

var direction = 1

const ACCELERATION = 100

enum {
	IDLE, MOVING, CHASING, ATTACKING
}

var state = ATTACKING
var states = [IDLE, MOVING, ATTACKING]
var attacks = ["attack1", "attack2", "special_attack"]

func _input(event):
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()

func _ready():
	randomize()
	animation_tree.active = true
	timer.timeout.connect(change_state)

func _physics_process(delta):
	#	update_is_killable(turn_pivot)
	if not is_on_floor():
		apply_gravity(delta)
	match state:
		IDLE:
			playback.travel("idle")
			velocity.x = move_toward(velocity.x, 0, ACCELERATION)
			
		MOVING:
			if wall.is_colliding() or not floor.is_colliding():
				direction *= -1
				pivot.scale.x = direction
			playback.travel("run")
			velocity.x = move_toward(velocity.x, speed * direction, ACCELERATION)
			
		ATTACKING:
			attack()
			
		CHASING:
			follow_player()
			playback.travel("run")
	
	move_and_slide()

func attack():
	velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	var current_attack = choose(attacks)
	playback.travel(current_attack)

func change_state():
	playback.travel("state_change")
	state = choose(states)

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
		state = IDLE