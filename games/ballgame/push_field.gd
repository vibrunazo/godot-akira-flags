extends Area2D

## Frees itself after this many seconds
@export var duration: float = 0.3
## FX to be instatiated at spawn
@export var fx_scene: PackedScene

## List of balls I already hit
var hit_list: Array[PlayerBall]

# Called when the node enters the scene tree for the first time.
func _ready():
	if fx_scene:
		var fx: Node2D = fx_scene.instantiate() as Node2D
		fx.global_position = global_position
		get_parent().add_child(fx)
	if duration > 0:
		await get_tree().create_timer(duration).timeout
		queue_free()



func _on_body_entered(body):
	if body is PlayerBall and not hit_list.has(body):
		var dir: Vector2 = body.global_position - global_position
		dir = dir.normalized()
		var power: float = 1400
		body.apply_impulse(dir * power)
		if body.has_method("play_hit"):
			body.play_hit(power * 0.7)
		hit_list.append(body)
