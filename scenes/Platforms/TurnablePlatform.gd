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
	pass

func _on_hit_turn():
	if is_turning:
		return
	is_turning = true 
	
	if tween:
		print("cum")
		tween.play()
	else:
		tween = create_tween()


	tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	var target_radians = turn_pivot.skew - (half_turns * PI)
	tween.tween_property(turn_pivot, "skew", target_radians, turn_time)
	tween.tween_property(self, "is_turning", false, 0)

func _stop_turning():
	tween.stop()
	is_turning = false

func take_hit(b):
	if b != tileset:
		print("cum")
		return
	if is_turning:
		_stop_turning()
	else:
		_on_hit_turn()

	
