extends Camera2D

var facing = 0
const LOOK_AHEAD_FACTOR = 0.2

const SHIFT_TRANS = Tween.TRANS_SINE
const SHIFT_EASE = Tween.EASE_OUT
const SHIFT_DURATION = 1.0

@onready var prev_cam_pos = get_target_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_check_facing()
	prev_cam_pos = get_target_position()

func _check_facing():
	var new_facing  = sign(get_target_position().x - prev_cam_pos.x)
	if new_facing != 0 && facing != new_facing:
		var tween = get_tree().create_tween()
		tween.set_trans(SHIFT_TRANS).set_ease(SHIFT_EASE)
		facing = new_facing
		var target_offset = get_viewport_rect().size.x * LOOK_AHEAD_FACTOR * facing
		tween.tween_property(self, "position", Vector2(target_offset, position.y), SHIFT_DURATION)

func _on_player_grounded_updated(is_grounded):
	drag_vertical_enabled = !is_grounded
