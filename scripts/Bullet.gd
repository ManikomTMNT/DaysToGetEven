extends Area2D

@export var speed: float = 300.0
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("hey")
	queue_free()
