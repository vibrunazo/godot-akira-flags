## A Button to select the next level
class_name LevelButton extends Button

@export_file("*.tscn") var level_scene: String


func _on_pressed():
	#get_tree().change_scene_to_file("res://quiz/quiz_game.tscn")
	if not level_scene: return
	get_tree().change_scene_to_file(level_scene)
	#get_tree().change_scene_to_packed(level_scene)
