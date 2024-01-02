## Game that holds Quiz questions
class_name QuizGame extends Node2D

## PackedScene that will be instantiated to create new questions
@export var question_scene: PackedScene
## Maximum number of questions to finish the game
@export var max_questions: int = 10

## referenec to the progress bar
@onready var progress: GameProgress = %GameProgress as GameProgress
@onready var anim: AnimationPlayer = $AnimationPlayer

## Holds a reference to the singleton QuizGame instance
static var game: QuizGame
## List of last answers
static var history_list: Array[CountryData]

## Reference to the current question
var question: QuizQuestion

# Called when the node enters the scene tree for the first time.
func _ready():
	game = self
	update_question(%QuizQuestion)
	progress.max_value = max_questions

## Adds a new country to the ignore list so this country is not the answer again
static func add_to_history(new_country: CountryData):
	history_list.append(new_country)
	# cannot ignore more than 3 because the options does not take ignored into account
	if history_list.size() > 3:
		history_list.pop_front()

## Static function that will call _restart_question on the singleton QuizGame instance
static func restart_question():
	game._restart_question()

## Restarts the question
func _restart_question():
	question.queue_free()
	var new_question: QuizQuestion = question_scene.instantiate() as QuizQuestion
	add_child(new_question)
	update_question(new_question)

## Set the new QuizQuestion, connect its signals
func update_question(new_question: QuizQuestion):
	question = new_question
	question.nailed.connect(_on_nailed)
	question.failed.connect(_on_failed)

## Nailed a question
func _on_nailed():
	progress.inc_value(1)
	await question.finished
	if progress.value < progress.max_value:
		_restart_question()
	else: 
		win()

## Plays win anim, restarts game
func win():
	print('win')
	question.queue_free()
	progress.play_win()
	await progress.animation_finished
	await get_tree().create_timer(1).timeout
	anim.play("end")
	await anim.animation_finished
	get_tree().reload_current_scene()

## Failed a question
func _on_failed():
	progress.inc_value(-1)


func _on_quit_button_confirmed():
	get_tree().quit()
