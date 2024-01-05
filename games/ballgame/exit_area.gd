extends Area2D

## Teleports to this Area2D when a body enters myself
@export var teleport_to: Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_body_entered(body):
	if body is PlayerBall:
		if teleport_to is SpawnArea:
			var to: Vector2 = teleport_to.get_random_point()
			#body.global_position = Vector2(to.x, to.y)
			body.global_position.x = to.x
			body.global_position.y = to.y
		else:
			body.global_position.y = -300
		#print('teleported to %s' % body.global_position)
			
