extends Camera2D

var facing = 0
const LOOK_AHEAD_FACTOR = 0.07

const SHIFT_TRANS = Tween.TRANS_SINE
const SHIFT_EASE = Tween.EASE_OUT
const SHIFT_DURATION = 1.0

@onready var prev_cam_pos = get_target_position()
@onready var tween = create_tween()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_check_facing()
	prev_cam_pos = get_target_position()
	

func _check_facing():
	var new_facing  = sign(get_target_position().x - prev_cam_pos.x)
	if new_facing != 0 && facing != new_facing:
		facing = new_facing
		var target_offset = get_viewport_rect().size.x * LOOK_AHEAD_FACTOR * facing
		tween.interpolate_value(position.x, target_offset - position.x, 0, SHIFT_DURATION, SHIFT_TRANS, SHIFT_EASE)
		
	
func _on_player_grounded_updated(is_grounded):
	drag_vertical_enabled = !is_grounded