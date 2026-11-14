extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	if Input.is_action_just_pressed("atk") and body.is_in_group("Enemy"):
		body.ow()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var koo = get_overlapping_bodies()
	for body in koo:
		_on_body_entered(body)
	
