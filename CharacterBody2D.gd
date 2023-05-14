extends CharacterBody2D

@onready var interaction_area = $InteractionArea
@onready var label = $Label
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += delta * gravity
	move_and_slide()

func _on_interaction_area_body_entered(body):
	if body is Player:
		animation_player.play("test")

func _on_interaction_area_body_exited(body):
	if body is Player:
		animation_player.play_backwards("test")
