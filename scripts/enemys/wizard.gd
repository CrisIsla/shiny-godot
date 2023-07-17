extends Enemy


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var projectile_scene: PackedScene

enum HOR_DIRECTIONS { LEFT = -1, RIGHT = 1 }
@export var direction: HOR_DIRECTIONS

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var timer = $Timer
@onready var projectile_spawn = $Pivot/ProjectileSpawn
@onready var pivot = $Pivot

enum {
	IDLE, SHOOTING
}
var state = IDLE

func _ready():
	timer.timeout.connect(_shoot)
	animation_tree.active = true

	scale.x = direction
	
func _physics_process(delta):
	# Add the gravity.
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
	projectile.initialize(direction)
	projectile_spawn.add_child(projectile)
	state = IDLE

	


