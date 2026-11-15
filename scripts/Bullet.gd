extends Area2D

@export var speed: float = 300.0
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		position += direction * speed * delta
	
	var lll = get_overlapping_bodies()
	for body in lll:
		if body.is_in_group("Player"):
			body.ow(sign(0), "firebull",150)
			queue_free()

	
	
