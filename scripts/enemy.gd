extends CharacterBody2D
class_name Enemy

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var speed: int
@export var jump_velocity: int
@export var hp: int
@export var damage: int
@export var is_killable: bool = true

func _physics_process(delta):
	if not is_on_floor():
		apply_gravity(delta)
	
	move_and_slide()

func apply_gravity(delta):
	velocity.y += gravity * delta
