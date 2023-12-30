extends Button

class_name FlagButton

@export var country_id: String = 'brazil'

# Called when the node enters the scene tree for the first time.
func _ready():
	icon = Countries.get_flag(country_id)

func _on_pressed():
	$AudioClick.play()
