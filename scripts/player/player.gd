extends CharacterBody2D


@export var speed = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_falling = false

@onready var pivot = $Pivot
@onready var animationPlayer = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	var direction = get_movement()

	if not is_on_floor():
		apply_gravity(delta)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
		
	if Input.is_action_just_pressed("attack"):
		attack()
	
	# handle anmimations
	handle_sprite_direction(direction)
	handle_movement_animations()
	
	move_and_slide()

func apply_gravity(delta):
	velocity.y += gravity * delta

func jump():
	velocity.y = JUMP_VELOCITY
	
func get_movement():
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	
	return direction
	
func attack():
	pass

func handle_movement_animations():
	if abs(velocity.x) > 0:
		playback.travel("run")
	
	if not velocity.x:
		playback.travel("idle")
	
	if velocity.y < 0:
		playback.travel("jump")
	
	if velocity.y > 0:
		playback.travel("fall")
		is_falling = true
	
	if is_falling and is_on_floor():
		playback.travel("landing")
		is_falling = false

func handle_sprite_direction(direction):
	if direction:
		pivot.scale.x = sign(direction)
