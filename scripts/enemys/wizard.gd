extends Enemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var projectile_scene: PackedScene

enum HOR_DIRECTIONS { LEFT = -1, RIGHT = 1 }
@export var direction: HOR_DIRECTIONS
@export var shoot_cooldown: float = 5.0
@export var projectile_speed: float = 100

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var timer = $Timer
@onready var projectile_spawn = $Pivot/ProjectileSpawn
@onready var pivot = $Pivot

var ON_HIT_KNOCKBACK = 200

enum {
	IDLE, SHOOTING
}
var state = SHOOTING

func _ready():
	turn_pivot = $Pivot/TurnPivot
	timer.wait_time = shoot_cooldown
	timer.timeout.connect(_shoot)
	animation_tree.active = true

	scale.x = direction
	
func _physics_process(delta):
	# Add the gravity.
	update_is_killable(turn_pivot)
	if not is_on_floor():
		velocity.y += gravity * delta
	
	_handle_states()
	move_and_slide()
	
func _handle_states():
	match state:
		IDLE:
			playback.travel("idle")
		SHOOTING:
			playback.travel("Shoot")
		
		
func _shoot():
	state = SHOOTING
	
func _spawn_projectile():
	# Add projectile as a child.
	var projectile = projectile_scene.instantiate()
	projectile.set_speed(projectile_speed)
	projectile_spawn.add_child(projectile)
	state = IDLE

func _on_hitbox_area_entered(area):
	if area.is_in_group("player_hurtbox"):
		var player = area.get_parent() as Player
		player.take_damage(damage)
		player.knockback(ON_HIT_KNOCKBACK, global_position)

