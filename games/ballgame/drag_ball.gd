## Ball that gets dragged by the mouse to move other balls
class_name DragBall extends RigidBody2D

@export var fx_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var dir: Vector2 = get_global_mouse_position() - global_position
	var vel: Vector2 = dir * delta * 500
	global_position = get_global_mouse_position()
	linear_velocity = vel
	if dir.length() < 10: 
		linear_velocity = Vector2.ZERO
	

func _on_area_2d_body_entered(body):
	if linear_velocity.length() < 10: return
	if body is PlayerBall:
		var dir: Vector2 = body.global_position - global_position
		dir = dir.normalized()
		
		var power: float = 500
		body.apply_impulse(dir * power + linear_velocity)
		if body.has_method("play_hit"):
			body.play_hit(power * 0.7)


func _on_timer_timeout():
	var fx: GPUParticles2D = fx_scene.instantiate() as GPUParticles2D
	fx.amount_ratio = 0.2
	fx.global_position = global_position
	get_parent().add_child(fx)
