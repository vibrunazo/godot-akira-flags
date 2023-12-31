extends ProgressBar

## Progress bar with a character moving along it to show progress in the game
class_name GameProgress

@onready var pchar: Char = %ProgressChar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func inc_value(inc: int):
	value += inc
	pchar.position.x = value * size.x / max_value
