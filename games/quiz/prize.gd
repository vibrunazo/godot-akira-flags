class_name Prize extends Node2D

@onready var anim: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func play_win():
	anim.play("eat")
