extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_killable = false

@onready var animationPlayer = $AnimationPlayer
#@onready var animation_tree = $AnimationTree
#@onready var playback = animation_tree.get("parameters/playback")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		

	move_and_slide()

func set_is_killable(argument: bool):
	is_killable = argument

func _on_area_2d_area_entered(area):
	$AnimationPlayer.play("idle_turn")
	if is_killable:
		queue_free()
