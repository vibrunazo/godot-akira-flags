extends Button

class_name FlagButton

@export var country_id: String = 'brazil'
@onready var audio: AudioStreamPlayer = $AudioClick

# Called when the node enters the scene tree for the first time.
func _ready():
	icon = Countries.get_flag(country_id)

func _on_pressed():
	audio.volume_db = -12
	audio.play()

func _on_button_down():
	audio.volume_db = 0
	audio.play()
