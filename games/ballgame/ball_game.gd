## A foot Ball game
class_name BallGame extends GameMode


@onready var game_layer: CanvasLayer = %GameLayer
@onready var net: Area2D = %Net
@onready var audio_goal: AudioStreamPlayer = $AudioGoal

## Is cooldown ready to spawn push fields
var is_spawn_ready := true
## Cooldown in seconds between new spawns
var spawn_cooldown := 0.1
# Score of each team
var scores: Array[int] = [0, 0]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if not is_spawn_ready: return
		spawn_push(get_global_mouse_position())

func spawn_push(pos: Vector2):
	var field := load("res://games/ballgame/push_field.tscn").instantiate() as Node2D
	field.global_position = pos
	game_layer.add_child(field)
	is_spawn_ready = false
	await get_tree().create_timer(spawn_cooldown).timeout
	is_spawn_ready = true
	


func _on_net_body_entered(body):
	if body is PlayerBall:
		print('goal!')
		audio_goal.play()
		scores[0] += 1
		%Score0.text = "%s" % scores[0]
	pass # Replace with function body.
