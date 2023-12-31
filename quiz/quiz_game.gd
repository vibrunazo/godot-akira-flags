extends Node2D


## Game that holds Quiz questions
class_name QuizGame

## PackedScene that will be instantiated to create new questions
@export var question_scene: PackedScene

@onready var progress: GameProgress = %GameProgress

## Holds a reference to the singleton QuizGame instance
static var game: QuizGame
static var last_answer: CountryData

## Reference to the current question
var question: QuizQuestion

# Called when the node enters the scene tree for the first time.
func _ready():
	game = self
	update_question(%QuizQuestion)

## Static function that will call _restart_question on the singleton QuizGame instance
static func restart_question():
	game._restart_question()

## Restarts the question
func _restart_question():
	question.queue_free()
	var new_question: QuizQuestion = question_scene.instantiate()
	add_child(new_question)
	update_question(new_question)

func update_question(new_question: QuizQuestion):
	question = new_question
	question.nailed.connect(_on_nailed)
	question.failed.connect(_on_failed)

func _on_nailed():
	progress.inc_value(1)

func _on_failed():
	progress.inc_value(-1)
