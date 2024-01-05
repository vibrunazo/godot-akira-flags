class_name SpawnArea extends Area2D

@onready var collision: CollisionShape2D = %CollisionShape2D

# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass

func get_random_point() -> Vector2:
	var shape: RectangleShape2D = collision.shape as RectangleShape2D
	var x1 := -shape.size.x / 2
	var x2 := shape.size.x / 2
	var y1 := -shape.size.y / 2
	var y2 := shape.size.y / 2
	var point := Vector2(randf_range(x1, x2), randf_range(y1, y2))
	#print('sizex: %s, x1: %s, gpos: %s' % [shape.size.x, x1, collision.global_position])
	return point + collision.global_position
