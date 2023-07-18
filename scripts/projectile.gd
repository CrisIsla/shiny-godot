extends Node2D

@export var SPEED = 50
@onready var animated_sprite_2d = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("default")

func _physics_process(delta):
	position.x += SPEED * delta
	
func set_speed(speed: float):
	SPEED = speed

func _on_area_2d_area_entered(area):
#	queue_free()
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
