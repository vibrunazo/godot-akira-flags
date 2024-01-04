class_name PlayerBall extends RigidBody2D

## id of the country this ball is teamed with
@export var team: String = 'brazil'

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_hit(vel):
	if vel < 80: return
	var vol: float = vel / 300
	var pitch: float = vel / 400
	audio.volume_db = linear_to_db(vol) * 1.6
	audio.pitch_scale = clamp(pitch, 0.2, 1.2)
	#print('entered ball vel: %s, db: %s, pitch: %s' % [linear_velocity.length(), audio.volume_db, audio.pitch_scale])
	audio.play()

func _on_body_entered(_body):
	var vel: float = linear_velocity.length()
	play_hit(vel)
	
