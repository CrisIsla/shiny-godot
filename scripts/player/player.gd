extends CharacterBody2D
class_name Player
signal grounded_updated(is_grounded)

@export var speed = 250.0
const JUMP_VELOCITY = -320.0
const ACCELERATION = 15
const SPEED = 250.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 0.8

var is_falling = false
var direction
var last_direction = 1
var is_grounded


@onready var pivot = $Pivot
@onready var animationPlayer = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var hitbox = $Pivot/Area2D/hitbox
@onready var canvas_layer = $CanvasLayer
@onready var coyote = $Coyote
@onready var ui = $CanvasLayer/UI
@onready var gpu_particles_2d = $Pivot/GPUParticles2D
@onready var invul_timer = $InvulTimer
@onready var camera_2d = $Camera2D

const DEFAULT_ZOOM: Vector2 = Vector2(0.8, 0.8)
const MIN_ZOOM: Vector2 = Vector2(0.6, 0.6)

@export var spawn_cords: Vector2 
@export var hp = 3:
	set(value):
		hp=value
		ui.set_health(value)

@onready var jump_sfx = $JumpSFX
@onready var attack_sfx = $AttackSFX

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
		
	if is_on_floor() or coyote.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			jump()
			
	var was_grounded = is_grounded
	is_grounded = is_on_floor()
	
	if was_grounded == null || is_grounded != was_grounded:
		emit_signal("grounded_updated", is_grounded)
		
	if not is_on_floor():
		apply_gravity(delta)
		if Input.is_action_just_released("jump") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2
		
	if Input.is_action_just_pressed("attack"):
		attack()
	
	if velocity.x != 0 and is_on_floor():
		gpu_particles_2d.emitting = true

	handle_movement_animations()
	
	get_movement()
	# Coyote jump logic
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote.start()
	
	if hp <= 0:
		death()

func apply_gravity(delta):
	velocity.y += gravity * delta

func jump():
	if hp <= 0:
		return
	velocity.y = JUMP_VELOCITY
	randomize()
	jump_sfx.set_pitch_scale(randf_range(0.8, 2.0))
	jump_sfx.play()
	
func get_direction():
	if hp <= 0:
		return 0
	return sign(Input.get_axis("move_left", "move_right"))
	
func get_movement():
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION)	
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
	
	velocity.x = clampf(velocity.x, -SPEED, SPEED)
	
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

func take_damage(damage):
	if invul_timer.time_left > 0:
		return
		
	invul_timer.start()
	hp -= damage
	playback.call_deferred("travel", "hurt")
	
func death():
	playback.travel("death")
	await get_tree().create_timer(1).timeout
	get_tree().reload_current_scene()

func knockback(knockback_scale: int, enemy_position: Vector2):
	var direction = (global_position - enemy_position).normalized()
	velocity = direction * knockback_scale

func _on_area_2d_area_entered(area):
	if area.get_parent() and area.get_parent() is Enemy:
		var enemy = area.get_parent() as Enemy
		enemy.take_hit()
