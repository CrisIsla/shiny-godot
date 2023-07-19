extends Node2D

@onready var turn_pivot = $Pivot/TurnPivot
@onready var tileset = $Pivot/TurnPivot/TilesetPlatform


var is_turning = false
var tween

@export var half_turns: int = 5
@export var turn_time: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.player.platform_hit.connect(take_hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_check_is_thin()

func _on_hit_turn():
	if is_turning:
		return
	is_turning = true 
		
	tween = create_tween()

	tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	var target_radians = turn_pivot.skew - (half_turns * PI)
	tween.tween_property(turn_pivot, "skew", target_radians, turn_time)
	tween.tween_property(self, "is_turning", false, 0)

func _stop_turning():
	tween.stop()
	is_turning = false
	
func _check_is_thin():
	var radians = fmod(abs(turn_pivot.skew), 2*PI)
	var dead_zone = 0.3 # in radians
	if (radians < PI/2 + dead_zone and radians > PI/2 - dead_zone) or (radians < 6*PI/4 + dead_zone and radians > 6*PI/4 - dead_zone):
		print("thin")

func take_hit(b):
	if b != tileset:
		return
	if is_turning:
		_stop_turning()
	else:
		_on_hit_turn()

	
