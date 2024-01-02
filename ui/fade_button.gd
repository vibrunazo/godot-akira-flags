## A Button that fades in slowly the first time it was pressed to only be activated when pressed again.
## Aims to reduce accidental clicks.
class_name FadeButton extends Button

## Button was pressed and is ready to receive clicks
signal confirmed

## After how long in seconds to fade out the button
@export var fade_duration: float = 2

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = Timer.new()

var is_ready := false

func _ready():
	timer.one_shot = true
	add_child(timer)

func _on_button_down():
	if anim.is_playing(): return
	if not is_ready:
		anim.play("fadein")
		await anim.animation_finished
		is_ready = true
	timer.start(fade_duration)
	await timer.timeout
	is_ready = false
	anim.play("fadeout")

func _on_pressed():
	if is_ready:
		confirmed.emit()
