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
	match state:
		IDLE:
			playback.travel("idle")
			
		MOVING:
			playback.travel("run")
			
		ATTACKING:
			attack()

func attack():
	var current_attack = choose(attacks)
	playback.travel(current_attack)
	state = IDLE

func change_state():
	state = choose(states)

func choose(array: Array):
	array.shuffle()
	return array[0]
