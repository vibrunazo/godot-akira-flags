## A Character that can move around
class_name Char extends Node2D

signal animation_finished

@onready var anim: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

## Plays the eat anim
func eat():
	anim.play("eat", 0.1)
	await anim.animation_finished
	anim.play("celebrate", 0.1)
	await anim.animation_finished
	anim.play("idle", 0.1)
	animation_finished.emit()

## Moves towards the target over time
func move_to(x: float, time: float = 1):
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", Vector2(x, position.y), time)
	print('moving to %s' % x)
	anim.play("walk", 0.1)
	tween.tween_callback(func(): anim.play("idle", 0.1))
