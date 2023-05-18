extends CharacterBody2D

@onready var interaction_area = $InteractionArea
@onready var label = $Label
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var animation_player_2 = $AnimationPlayer2

var current_label_animation = null
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	label.visible_ratio = 0

func _physics_process(delta):
	if Game.player:
		sprite_2d.flip_h = Game.player.global_position.x < global_position.x
	if not is_on_floor():
		velocity.y += delta * gravity
	move_and_slide()

func _on_interaction_area_body_entered(body):
	if body is Player:
		for j in range(len(animation_player_2.get_animation_list()) - 1):
			if current_label_animation == "":
				break
			animation_player_2.play("dialogue"+str(j))
			current_label_animation = animation_player_2.current_animation
			await animation_player_2.animation_finished

func _on_interaction_area_body_exited(body):
	if body is Player and current_label_animation != null:
		animation_player_2.play_backwards(current_label_animation)
		current_label_animation = ""
		await animation_player_2.animation_finished
		current_label_animation = null
