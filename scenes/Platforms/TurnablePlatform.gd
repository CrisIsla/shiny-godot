extends Node2D

var is_turning = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_hit_turn(turn_pivot: Node2D, half_turns: int, turn_time: float):
	if is_turning:
		return
	is_turning = true 
	
