class_name GameCam extends Camera2D

## Initial position I started with, used to be able to reset to it later
@onready var ini_pos = global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

## Smoothly focuses on the target global position
func focus_target(pos: Vector2):
	global_position = pos
	var tween: Tween = create_tween() as Tween
	tween.tween_property(self, "zoom", Vector2(2, 2), 0.6)

## Resets back to initial position
func reset():
	global_position = ini_pos
	var tween: Tween = create_tween() as Tween
	tween.tween_property(self, "zoom", Vector2(1, 1), 0.5)
