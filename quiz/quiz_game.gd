extends Node2D


## Game that holds Quiz questions
class_name QuizGame

static var game: QuizGame
var question: QuizQuestion

# Called when the node enters the scene tree for the first time.
func _ready():
	game = self
	question = %QuizQuestion

## Static function that will call restart on the singleton QuizGame instance
static func restart_question():
	game._restart_question()

## Restarts the question
func _restart_question():
	question.queue_free()
	var new_question: QuizQuestion = load("res://quiz/quiz_question.tscn").instantiate()
	add_child(new_question)
	question = new_question
