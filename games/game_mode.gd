## Common functionality for all Games
class_name GameMode extends Node2D


## The path to change to when exiting the current scene
@export var previous_scene: String = "res://ui/level_select.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_quit_button_confirmed():
	if not previous_scene: return
	get_tree().change_scene_to_file(previous_scene)
	#get_tree().change_scene_to_packed(previous_scene)
