## A Character that can move around
class_name Char extends Node2D

signal animation_finished

@onready var anim: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func eat():
	anim.play("eat")
	await anim.animation_finished
	anim.play("celebrate")
	await anim.animation_finished
	anim.play("idle")
	animation_finished.emit()
