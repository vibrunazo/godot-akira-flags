extends Node2D


## Game that holds Quiz questions
class_name QuizGame

## PackedScene that will be instantiated to create new questions
@export var question_scene: PackedScene

## Holds a reference to the singleton QuizGame instance
static var game: QuizGame
static var last_answer: CountryData

## Reference to the current question
var question: QuizQuestion

# Called when the node enters the scene tree for the first time.
func _ready():
	game = self
	question = %QuizQuestion

## Static function that will call _restart_question on the singleton QuizGame instance
static func restart_question():
	game._restart_question()

## Restarts the question
func _restart_question():
	question.queue_free()
	var new_question: QuizQuestion = question_scene.instantiate()
	add_child(new_question)
	question = new_question
