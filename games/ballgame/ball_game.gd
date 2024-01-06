## A foot Ball game
class_name BallGame extends GameMode

## Array of team ids
@export var teams: Array[String] = ['uk', 'uruguay']
## Amount of balls per team
@export var max_balls: int = 3
## Time in seconds the match lasts
@export var max_time: float = 45

@onready var game_layer: Node = %GameLayer
@onready var net: Area2D = %Net
@onready var audio_goal: AudioStreamPlayer = $AudioGoal
@onready var audio_from: AudioStreamPlayer = $AudioFrom
@onready var audio_country: AudioStreamPlayer = $AudioCountry
@onready var label_score0: Label = %Score0
@onready var label_score1: Label = %Score1
@onready var label_time: Label = %LabelTime
@onready var sprite_flag0: Sprite2D = %SpriteFlag0
@onready var sprite_flag1: Sprite2D = %SpriteFlag1
@onready var balls_layer: Node2D = $GameLayer/balls
@onready var spawn_area: SpawnArea = %SpawnArea

## Is the game in a playable state. If false, the game is over
var is_ready := true
## Is cooldown ready to spawn push fields
var is_spawn_ready := true
## Cooldown in seconds between new spawns
var spawn_cooldown := 0.1
## Score of each team
var scores: Array[int] = [0, 0]
## If mouse has being held down
var is_mouse_down: bool = false
## Ball that gets dragged by the mouse
var drag_ball: DragBall
## Ellapsed time on the match, up to [member max_time]
var time: float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	start()

## Starts a new game
func start():
	is_ready = true
	time = 0
	scores = [0, 0]
	pick_teams()
	update_flags()
	spawn_balls()
	update_ui_time()
	update_ui_score()

## Resets the game, by deleting all balls. Then starts all over
func re_start():
	var balls: Array = balls_layer.get_children()
	for ball: PlayerBall in balls:
		ball.queue_free()
	start()

## Spawns all balls for all teams
func spawn_balls():
	for team: String in teams:
		for i in range(max_balls):
			spawn_ball(team)

## Spawns a single ball for a given team
func spawn_ball(team_id: String):
	print('spawn ball %s' % team_id)
	var ball_scene := load("res://games/ballgame/player_ball.tscn") as PackedScene
	var ball := ball_scene.instantiate() as PlayerBall
	ball.team = team_id
	ball.global_position = spawn_area.get_random_point()
	balls_layer.add_child(ball)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			is_mouse_down = true
			if not drag_ball:
				spawn_drag_ball()
			
			if not is_spawn_ready: return
			spawn_push(get_global_mouse_position())
		if event.is_released():
			is_mouse_down = false
			if drag_ball:
				drag_ball.queue_free()
				drag_ball = null

## picks random teams to play the game
func pick_teams():
	var ids: = Countries.ids.duplicate()
	ids.shuffle()
	teams[0] = ids.pop_front()
	teams[1] = ids.pop_front()

## Spawns the force field that pushes balls away
func spawn_push(pos: Vector2):
	if not is_ready: return
	var field := load("res://games/ballgame/push_field.tscn").instantiate() as Node2D
	field.global_position = pos
	game_layer.add_child(field)
	is_spawn_ready = false
	await get_tree().create_timer(spawn_cooldown).timeout
	is_spawn_ready = true

## Spawns the DragBall that gets dragged with the mouse and assign it to [member drag_ball]
func spawn_drag_ball():
	if not is_ready: return
	var ball := load("res://games/ballgame/drag_ball.tscn").instantiate() as Node2D
	game_layer.add_child(ball)
	drag_ball = ball
	drag_ball.global_position = get_global_mouse_position()
	
## Stops all audio from playing to avoid interruption
func stop_audio():
	audio_country.stop()
	audio_from.stop()
	audio_goal.stop()

func _on_net_body_entered(body):
	if not is_ready: return
	if body is PlayerBall:
		var team: String = body.team
		print('goal!')
		body.global_position.x = 0
		body.global_position.y = -300
		
		stop_audio()
		audio_goal.play()
		inc_team_score(team)
		update_ui_score()
		await audio_goal.finished
		audio_from.stream = Countries.get_pronoun_audio(team)
		audio_from.play()
		await audio_from.finished
		var stream := Countries.get_audio(team)
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
	
## Updates UI Labels with current score
func update_ui_score():
	label_score0.text = "%s" % scores[0]
	label_score1.text = "%s" % scores[1]

## Update texture of UI score flag sprites with current team countries
func update_flags():
	sprite_flag0.texture = Countries.get_flag(teams[0])
	sprite_flag1.texture = Countries.get_flag(teams[1])
	#var index: int = 0
	#var balls: Array = balls_layer.get_children()
	#for ball: PlayerBall in balls:
		#if index < balls.size() * 0.5:
			#ball.team = teams[0]
		#else:
			#ball.team = teams[1]
		#ball.update_country()
		#index += 1



func _on_timer_timeout():
	if time >= max_time: 
		end()
		return
	time += 1
	update_ui_time()

## Updates the UI with the ellapsed time
func update_ui_time():
	label_time.text = "%s" % round(time)

func end():
	if not is_ready: return
	is_ready = false
	await get_tree().create_timer(2).timeout
	print('game over, restarting')
	re_start()
