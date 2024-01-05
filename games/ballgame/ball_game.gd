## A foot Ball game
class_name BallGame extends GameMode

## Array of team ids
@export var teams: Array[String] = ['uk', 'uruguay']

@onready var game_layer: Node = %GameLayer
@onready var net: Area2D = %Net
@onready var audio_goal: AudioStreamPlayer = $AudioGoal
@onready var audio_from: AudioStreamPlayer = $AudioFrom
@onready var audio_country: AudioStreamPlayer = $AudioCountry
@onready var label_score0: Label = %Score0
@onready var label_score1: Label = %Score1
@onready var sprite_flag0: Sprite2D = %SpriteFlag0
@onready var sprite_flag1: Sprite2D = %SpriteFlag1
@onready var balls_layer: Node2D = $GameLayer/balls

## Is cooldown ready to spawn push fields
var is_spawn_ready := true
## Cooldown in seconds between new spawns
var spawn_cooldown := 0.1
## Score of each team
var scores: Array[int] = [0, 0]


# Called when the node enters the scene tree for the first time.
func _ready():
	pick_teams()
	update_flags()
	#(%Camera2D as Camera2D)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if not is_spawn_ready: return
		spawn_push(get_global_mouse_position())

func pick_teams():
	var ids: = Countries.ids.duplicate()
	ids.shuffle()
	teams[0] = ids.pop_front()
	teams[1] = ids.pop_front()

func spawn_push(pos: Vector2):
	var field := load("res://games/ballgame/push_field.tscn").instantiate() as Node2D
	field.global_position = pos
	game_layer.add_child(field)
	is_spawn_ready = false
	await get_tree().create_timer(spawn_cooldown).timeout
	is_spawn_ready = true
	
## Stops all audio from playing to avoid interruption
func stop_audio():
	audio_country.stop()
	audio_from.stop()
	audio_goal.stop()

func _on_net_body_entered(body):
	if body is PlayerBall:
		print('goal!')
		body.global_position.x = 0
		body.global_position.y = -300
		
		stop_audio()
		audio_goal.play()
		inc_team_score(body.team)
		update_ui_score()
		await audio_goal.finished
		audio_from.stream = Countries.get_pronoun_audio(body.team)
		audio_from.play()
		await audio_from.finished
		var stream := Countries.get_audio(body.team)
		audio_country.stream = stream
		audio_country.play()
		
## Sets the score for given country id
func set_score_for_team(id: String, new_score: int):
	var index: int = teams.find(id)
	scores[index] = new_score

## returns the score for given country id
func get_score_for_team(id: String) -> int:
	var index: int = teams.find(id)
	return scores[index]

## Increaments the score of given team
func inc_team_score(id: String, inc: int = 1):
	set_score_for_team(id, get_score_for_team(id) + inc)
	
func update_ui_score():
	label_score0.text = "%s" % scores[0]
	label_score1.text = "%s" % scores[1]

func update_flags():
	sprite_flag0.texture = Countries.get_flag(teams[0])
	sprite_flag1.texture = Countries.get_flag(teams[1])
	var index: int = 0
	var balls: Array = balls_layer.get_children()
	for ball: PlayerBall in balls:
		if index < balls.size() * 0.5:
			ball.team = teams[0]
		else:
			ball.team = teams[1]
		ball.update_country()
		index += 1

