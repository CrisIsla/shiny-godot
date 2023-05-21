extends CharacterBody2D

@onready var interaction_area = $InteractionArea
@onready var label = $Label
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var dialog_0 = $Dialogs/Dialog0
@onready var dialog_idle = $DialogIdle

var current_label_animation = null
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_animation_player: AnimationPlayer

@export var start: int
@export var end: int

func _ready():
	dialog_idle.visible = true
	label.visible_ratio = 0

func _physics_process(delta):
	if Game.player:
		sprite_2d.flip_h = Game.player.global_position.x < global_position.x
	if not is_on_floor():
		velocity.y += delta * gravity
	move_and_slide()

func _on_interaction_area_body_entered(body):
	if body.is_in_group("player"):
		dialog_idle.visible = false
		for j in range(start, end):
			if current_label_animation == "":
				break
			dialog_0.play("dialogue"+str(j))
			current_label_animation = dialog_0.current_animation
			await dialog_0.animation_finished

func _on_interaction_area_body_exited(body):
	if body.is_in_group("player") and current_label_animation != null:
		dialog_0.play_backwards(current_label_animation)
		current_label_animation = ""
		await dialog_0.animation_finished
		dialog_idle.visible = true
		current_label_animation = null
