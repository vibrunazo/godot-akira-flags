## Progress bar with a character moving along it to show progress in the game
class_name GameProgress extends ProgressBar

signal animation_finished

@onready var pchar: Char = %ProgressChar
@onready var prize: Prize = %Prize

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

## Incremeants the value and updates the Char position
func inc_value(inc: int):
	value += inc
	update_char()

func update_char():
	pchar.position.x = value * size.x / max_value

## Play win animation
func play_win():
	pchar.eat()
	prize.play_win()
	await pchar.animation_finished
	animation_finished.emit()

## Resets to starting values
func reset():
	value = 0
	update_char()
	
