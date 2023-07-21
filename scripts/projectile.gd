extends Node2D

@export var SPEED = 50
@export var DAMAGE = 1
var ON_HIT_KNOCKBACK = 500
@onready var animated_sprite_2d = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("default")

func _physics_process(delta):
	position.x += SPEED * delta
	
func set_speed(speed: float):
	SPEED = speed


func _on_hitbox_area_entered(area):
	if area.is_in_group("player_hurtbox"):
		var player = area.get_parent() as Player
		player.take_damage(DAMAGE)
		player.knockback(ON_HIT_KNOCKBACK, global_position)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	pass
#	queue_free()


