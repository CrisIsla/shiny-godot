extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	tile_set.set_physics_layer_collision_layer(0, 5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
