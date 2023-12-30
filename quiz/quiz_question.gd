extends CanvasLayer

## A single question in the quiz game
class_name QuizQuestion

## List of countries that will show up as options in the quiz
@export var options: Array[CountryData]
## Number of options per quiz
@export var max_options: int = 4
## The fx to instantiate and play when a correct answer is picked
@export var yes_fx: PackedScene

@onready var root: Control = $HBoxContainer
@onready var grid: GridContainer = %GridContainer
@onready var label_ask: Label = %LabelAsk
@onready var label_answer: Label = %LabelAnswer
@onready var audio_question: AudioStreamPlayer = %AudioQuestion
@onready var audio_answer: AudioStreamPlayer = %AudioAnswer
@onready var audio_pressed: AudioStreamPlayer = %AudioFlagPressed
@onready var audio_yes: AudioStreamPlayer = %AudioYes
@onready var audio_no: AudioStreamPlayer = %AudioNo
@onready var audio_isnot: AudioStreamPlayer = %AudioIsNot
@onready var anim: AnimationPlayer = %Anim
## id of the correct answer
var answer: CountryData

var is_ready := false

# Called when the node enters the scene tree for the first time.
func _ready():
	build_grid()
	update_ui()
	await get_tree().create_timer(0.6).timeout
	ask_question()

## Builds the grid with random options and picks a random answer
func build_grid():
	var candidates := Countries.ids.duplicate()
	candidates.shuffle()
	options = []
	for child: Node in grid.get_children():
		child.queue_free()
	for i in range(max_options):
		var id: String = candidates.pop_back()
		var data: CountryData = Countries.get_data(id)
		options.append(data)
		var button: FlagButton = load("res://quiz/flag_button.tscn").instantiate()
		button.country_id = id
		button.pressed.connect(_on_flag_pressed.bind(button))
		grid.add_child(button)
	options.erase(QuizGame.last_answer)
	answer = options.pick_random()
	QuizGame.last_answer = answer
	
## Updates the UI with text from the quiz
func update_ui():
	if not answer: 
		printerr('null answer')
		return
	label_answer.text = answer.display_name
	audio_answer.stream = Countries.get_audio(answer.id)

## Plays the audio and anim to ask the quiz question
func ask_question():
	#is_ready = false
	animate_control(label_ask)
	audio_question.play()
	await audio_question.finished
	audio_answer.play()
	#anim.play('ask')
	animate_control(label_answer)
	await get_tree().create_timer(0.2).timeout
	#await audio_answer.finished
	is_ready = true

## A flag button option was pressed
func _on_flag_pressed(button: FlagButton):
	if not is_ready: return
	print('pressed %s, answer: %s' % [button.country_id, answer.id])
	animate_control(button)
	audio_pressed.stream = Countries.get_audio(button.country_id)
	stop_audio()
	if button.country_id == answer.id:
		play_correct(button.global_position + button.pivot_offset)
	else:
		play_wrong()

## Stops all audio from playing so I can play new ones without speaking over others
func stop_audio():
	audio_question.stop()
	audio_answer.stop()
	audio_no.stop()
	audio_pressed.stop()
	audio_isnot.stop()

## Plays audio and anim for choosing the correct anwer
func play_correct(pos: Vector2):
	is_ready = false
	anim.play('yes')
	anim.seek(0)
	animate_control(root, 1.05)
	spawn_yes_fx(pos)
	audio_yes.play()
	await audio_yes.finished
	anim.play('end')
	await get_tree().create_timer(0.7).timeout
	#get_tree().change_scene_to_file("res://quiz/quiz_question.tscn")
	QuizGame.restart_question()

func spawn_yes_fx(pos: Vector2):
	var fx = yes_fx.instantiate()
	fx.global_position = pos
	add_child(fx)

## Plays audio and anim for picking a wrong option
func play_wrong():
	anim.play('fail')
	anim.seek(0)
	audio_no.play()
	await audio_no.finished
	audio_pressed.play()
	await audio_pressed.finished
	audio_isnot.play()
	await audio_isnot.finished
	audio_answer.play()
	await audio_answer.finished
	ask_question()

## Plays a bouncing wiggle anim on a given control. Will return to 1,1 scale once finished.
func animate_control(label: Control, to: float = 1.25):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(label, "scale", Vector2(to, to), 0.08)
	await tween.finished
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.6)

## Pressed the button to ask the question again
func _on_ask_button_pressed():
	if not is_ready: return
	stop_audio()
	ask_question()
