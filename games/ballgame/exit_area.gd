extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_body_entered(body):
	print(body)
	if body is PlayerBall:
		body.global_position.y = -300
	pass # Replace with function body.
