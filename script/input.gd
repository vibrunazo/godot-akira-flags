extends Node

## Input autoload singleton

# Called when the node enters the scene tree for the first time.
func _ready():
	# so the Global inputs can still be handled while paused
	process_mode = Node.PROCESS_MODE_ALWAYS


## Calls toggle_fullscreen when "ui_fullscreen" is pressed
func _unhandled_input(event):
	if event.is_action_pressed("ui_fullscreen"):
		toggle_fullscreen()

## Toggles fullscreen
func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
