extends CanvasLayer

@onready var hearts = $full_heart

func set_health(value):
	hearts.size.x = 128 * value
