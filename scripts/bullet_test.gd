extends Node2D

@export var SPEED = 20
@onready var animated_sprite_2d = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("default")

func _physics_process(delta):
	global_position.x -= SPEED * delta
	


func _on_area_2d_area_entered(area):
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
