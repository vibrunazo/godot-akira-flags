## Progress bar with a character moving along it to show progress in the game
class_name GameProgress extends ProgressBar

signal animation_finished

@onready var pchar: Char = %ProgressChar
@onready var prize: Prize = %Prize

## Target value for the progress bar, [member value] will be slowly animated towards target
var target: float = 0

func _ready():
	value = 0

## Incremeants the value and updates the Char position
func inc_value(inc: int):
	target += inc
	target = clamp(target, min_value, max_value)
	if target == value: return
	var tween: Tween = create_tween()
	tween.tween_property(self, "value", target, 1)
	move_char_to(target)

func move_char_to(to: float):
	pchar.move_to(to * size.x / max_value)

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
	
