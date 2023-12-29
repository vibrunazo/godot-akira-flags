extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	ask_question()


func ask_question():
	$AudioQuestion.play()
	await $AudioQuestion.finished
	$AudioFlag.play()

func _on_flag_button_pressed():
	$AudioYes.play()


func _on_flag_button_2_pressed():
	$AudioNo.play()
	await $AudioNo.finished
	ask_question()
