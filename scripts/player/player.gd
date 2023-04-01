extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		apply_gravity(delta)

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
		
	if Input.is_action_just_pressed("attack"):
		attack()

	get_movement()
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
	
func attack():
	pass
	
