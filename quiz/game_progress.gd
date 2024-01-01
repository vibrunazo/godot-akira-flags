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
	#value += inc
	var target := value + inc
	target = clamp(target, min_value, max_value)
	if target == value: return
	var tween: Tween = create_tween()
	tween.tween_property(self, "value", target, 1)
	#tween.tween_callback(update_char)
	move_char_to(target)

func move_char_to(to: float):
	pchar.move_to(to * size.x / max_value)

func update_char():
	#pchar.move_to(value * size.x / max_value)
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
	
