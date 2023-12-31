## Game that holds Quiz questions
class_name QuizGame extends Node2D

## PackedScene that will be instantiated to create new questions
@export var question_scene: PackedScene
## Maximum number of questions to finish the game
@export var max_questions: int = 2

## referenec to the progress bar
@onready var progress: GameProgress = %GameProgress as GameProgress

## Holds a reference to the singleton QuizGame instance
static var game: QuizGame
static var last_answer: CountryData

## Reference to the current question
var question: QuizQuestion

# Called when the node enters the scene tree for the first time.
func _ready():
	game = self
	update_question(%QuizQuestion)
	progress.max_value = max_questions

## Static function that will call _restart_question on the singleton QuizGame instance
static func restart_question():
	game._restart_question()

## Restarts the question
func _restart_question():
	question.queue_free()
	var new_question: QuizQuestion = question_scene.instantiate() as QuizQuestion
	add_child(new_question)
	update_question(new_question)

func update_question(new_question: QuizQuestion):
	question = new_question
	question.nailed.connect(_on_nailed)
	question.failed.connect(_on_failed)

func _on_nailed():
	progress.inc_value(1)
	await question.finished
	print('progress: %s' % progress.value)
	if progress.value < progress.max_value:
		_restart_question()
	else: 
		print('win')
		question.queue_free()
		progress.play_win()

func _on_failed():
	progress.inc_value(-1)
