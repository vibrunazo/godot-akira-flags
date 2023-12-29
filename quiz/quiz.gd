extends Node2D

## List of countries that will show up as options in the quiz
@export var options: Array[CountryData]
## Number of options per quiz
@export var max_options: int = 4

@onready var grid: GridContainer = %GridContainer
@onready var label_answer: Label = %LabelAnswer
@onready var audio_question: AudioStreamPlayer = %AudioQuestion
@onready var audio_answer: AudioStreamPlayer = %AudioAnswer
@onready var audio_pressed: AudioStreamPlayer = %AudioFlagPressed
@onready var audio_yes: AudioStreamPlayer = %AudioYes
@onready var audio_no: AudioStreamPlayer = %AudioNo
@onready var audio_isnot: AudioStreamPlayer = %AudioIsNot
## id of the correct answer
var answer: CountryData

var is_ready := false

# Called when the node enters the scene tree for the first time.
func _ready():
	build_grid()
	update_ui()
	ask_question()

func build_grid():
	var candidates := Countries.ids.duplicate()
	candidates.shuffle()
	options = []
	for i in range(max_options):
		var id: String = candidates.pop_back()
		var data: CountryData = Countries.get_data(id)
		options.append(data)
		var button: FlagButton = load("res://quiz/flag_button.tscn").instantiate()
		button.country_id = id
		button.pressed.connect(_on_flag_pressed.bind(button))
		grid.add_child(button)
	answer = options.pick_random()
	

func update_ui():
	if not answer: 
		printerr('null answer')
		return
	label_answer.text = answer.display_name
	audio_answer.stream = Countries.get_audio(answer.id)


func ask_question():
	audio_question.play()
	await audio_question.finished
	audio_answer.play()
	await audio_answer.finished
	is_ready = true

func _on_flag_pressed(button: FlagButton):
	if not is_ready: return
	is_ready = false
	print('pressed %s, answer: %s' % [button.country_id, answer.id])
	audio_pressed.stream = Countries.get_audio(button.country_id)
	if button.country_id == answer.id:
		play_correct()
	else:
		play_wrong()
	

func play_correct():
	audio_yes.play()
	await audio_yes.finished
	await get_tree().create_timer(0.7).timeout
	get_tree().change_scene_to_file("res://quiz/quiz.tscn")


func play_wrong():
	audio_no.play()
	await audio_no.finished
	audio_pressed.play()
	await audio_pressed.finished
	audio_isnot.play()
	await audio_isnot.finished
	audio_answer.play()
	await audio_answer.finished
	ask_question()
