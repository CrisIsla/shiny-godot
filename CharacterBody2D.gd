extends CharacterBody2D

@onready var interaction_area = $InteractionArea
@onready var label = $Label
@export var label_text = ""
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var animation_player_2 = $AnimationPlayer2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	label.visible_ratio = 0
	label.text = label_text

func _physics_process(delta):
	if Game.player:
		sprite_2d.flip_h = Game.player.global_position.x < global_position.x
	if not is_on_floor():
		velocity.y += delta * gravity
	move_and_slide()

func _on_interaction_area_body_entered(body):
	if body is Player:
		animation_player_2.play("dialogue")

func _on_interaction_area_body_exited(body):
	if body is Player:
		animation_player_2.play_backwards("dialogue")
