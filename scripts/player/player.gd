extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var pivot = $Pivot
@onready var animationPlayer = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")


func _physics_process(delta):
	var direction = get_movement()
	# Add the gravity.
	if not is_on_floor():
		apply_gravity(delta)

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
		
	if Input.is_action_just_pressed("attack"):
		attack()
	
	# handle anmimations
	handle_sprite_direction(direction)
	
	if abs(velocity.x) > 0:
		playback.travel("run")
	
	if not velocity.x:
		playback.travel("idle")
	
	move_and_slide()

func apply_gravity(delta):
	velocity.y += gravity * delta
	
func jump():
	velocity.y = JUMP_VELOCITY
	
func get_movement():
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	return direction
	
func attack():
	pass

func handle_sprite_direction(direction):
	if direction:
		pivot.scale.x = sign(direction)
