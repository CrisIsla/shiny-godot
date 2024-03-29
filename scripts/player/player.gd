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
var can_move = true

@onready var pivot = $Pivot
@onready var animationPlayer = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var hitbox = $Pivot/Area2D/hitbox
@onready var hitbox_area_2d = $Pivot/Area2D
@onready var canvas_layer = $CanvasLayer
@onready var coyote = $Coyote
@onready var ui = $CanvasLayer/UI
@onready var gpu_particles_2d = $Pivot/GPUParticles2D
@onready var invul_timer = $InvulTimer
@onready var camera_2d = $Camera2D
@onready var panel_container = $CanvasLayer/PanelContainer
@onready var black_bars = $BlackBars

const DEFAULT_ZOOM: Vector2 = Vector2(0.8, 0.8)
const MIN_ZOOM: Vector2 = Vector2(0.6, 0.6)

@export var hp = 3:
	set(value):
		hp=value
		ui.set_health(value)

@onready var jump_sfx = $JumpSFX
@onready var hurt_sfx = $HurtSFX
@onready var attack_sfx = $AttackSFX

# Cutscene logic
var cutscene_played: bool = false
@onready var cutscene = $Cutscene
@onready var cutscene_camera = $Cutscene_camera
signal cutscene_finished

# Tileset logic
signal platform_hit(platform)

func _ready():
	Game.player = self
	animation_tree.active = true
	hitbox.disabled = true
	canvas_layer.visible = true
	ui.visible = true
	panel_container.visible = true
	black_bars.visible = true
	LevelTransition.started.connect(player_cant_move)
	LevelTransition.finished.connect(player_can_move)

func player_cant_move():
	print("cant move")
	can_move = false

func player_can_move():
	print("can move")	
	can_move = true

func _input(event):
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()

func _physics_process(delta):
	# Player can't move during level transitions
	if not can_move:
		velocity.x = 0
		move_and_slide()
		handle_movement_animations()
		return
	
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
	jump_sfx.set_pitch_scale(randf_range(0.6, 1))
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
	
func _detect_platform_on_hit():
	var bodies = hitbox_area_2d.get_overlapping_bodies()
	for b in bodies:
		if b.name == 'TilesetPlatform':
			platform_hit.emit(b)
	
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
	hurt_sfx.play()
	playback.call_deferred("travel", "hurt")
	
func death():
	playback.travel("death")
	await get_tree().create_timer(1).timeout
	get_tree().reload_current_scene()

func knockback(knockback_scale: int, enemy_position: Vector2):
	direction = (global_position - enemy_position).normalized()
	velocity = direction * knockback_scale

func _on_area_2d_area_entered(area):
	if area.get_parent() and area.get_parent() is Enemy:
		var enemy = area.get_parent() as Enemy
		enemy.take_hit()



func door_cutscene():
	if !cutscene_played:
		can_move = false
		var door_position = Vector2(2750, -410)
		var tween = create_tween()
		cutscene.play("door")
		tween.tween_property(cutscene_camera, "global_position", door_position, 6).set_trans(Tween.TRANS_SINE).set_delay(1)
		tween.tween_property(cutscene_camera, "global_position", cutscene_camera.global_position, 3.5).set_delay(1).set_trans(Tween.TRANS_SINE)
		await tween.finished
		cutscene.play_backwards("door")
		await cutscene.animation_finished
		cutscene.play("RESET")
		cutscene_played = true
		can_move = true
		emit_signal("cutscene_finished")
