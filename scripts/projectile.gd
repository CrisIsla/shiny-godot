extends Node2D

@export var SPEED = 50
@onready var animated_sprite_2d = $AnimatedSprite2D
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("default")
	scale.x = direction

func _physics_process(delta):
	global_position.x += SPEED * delta * direction
	scale.x = direction
	
	

func initialize(initial_direction: int):
	direction = initial_direction

	
func _on_area_2d_area_entered(area):
#	queue_free()
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
