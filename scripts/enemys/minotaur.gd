extends Enemy

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var timer = $Timer

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
#	if can_move:
#		move()
	match state:
		IDLE:
			playback.travel("idle")
			
		MOVING:
			playback.travel("run")
			
		ATTACKING:
			attack()
	
	move_and_slide()

func attack():
	var current_attack = choose(attacks)
	playback.travel(current_attack)

func change_state():
	playback.travel("state_change")
	state = choose(states)

func choose(array: Array):
	array.shuffle()
	return array[0]
