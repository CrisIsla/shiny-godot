extends CharacterBody2D
class_name Player

const JUMP_VELOCITY = -400.0
const ACCELERATION = 15
const SPEED = 250.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_falling = false
var direction
var last_direction = 1

@onready var pivot = $Pivot
@onready var animationPlayer = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var hitbox = $Pivot/Area2D/hitbox
@onready var canvas_layer = $CanvasLayer

@onready var camera_2d = $Camera2D
const DEFAULT_ZOOM: Vector2 = Vector2(0.8, 0.8)
const MIN_ZOOM: Vector2 = Vector2(0.6, 0.6)

@export var hp = 3

func _ready():
	Game.player = self
	animation_tree.active = true
	hitbox.disabled = true
	canvas_layer.visible = true

func _input(event):
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	
	if event.is_action_pressed("camera"):
		if camera_2d.zoom.x < MIN_ZOOM.x:
			camera_2d.zoom = DEFAULT_ZOOM
		else:
			camera_2d.zoom /= Vector2(2, 2)

func _physics_process(delta):
	direction = get_direction()
	set_last_direction()

	if not is_on_floor():
		apply_gravity(delta)
		
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			jump()
	else:
		if Input.is_action_just_released("jump") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2
		
	if Input.is_action_just_pressed("attack"):
		attack()
	

	handle_movement_animations()
	
	get_movement()
	move_and_slide()

func apply_gravity(delta):
	velocity.y += gravity * delta

func jump():
	velocity.y = JUMP_VELOCITY
	
func get_direction():
	return Input.get_axis("move_left", "move_right")
	
func get_movement():
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	
func attack():
	playback.call_deferred("travel", "attack_1")

func handle_movement_animations():
	var sprite_direction = pivot.scale.x
	if direction:
		if sprite_direction != direction:
			playback.travel("run_turn")
			
		else:
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
	
	if direction and sprite_direction != direction and !is_on_floor():
		playback.travel("jump_turn")

func handle_sprite_direction():
	pivot.scale.x = last_direction

func set_last_direction():
	if direction:
		last_direction = direction
