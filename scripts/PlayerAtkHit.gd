extends Area2D

signal Atk

var is_atking = false;


func check_coll(body: Node2D) -> void:
	if is_atking && body.is_in_group("Enemy"):
		body.ow()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("atk"):
		is_atking = true;
		get_parent().atk();
		#$AtkIndicator.visible = true;
		$Timer.wait_time = 0.2;
		$Timer.start();
	
	var koo = get_overlapping_bodies()
	for body in koo:
		check_coll(body)


func _on_timer_timeout() -> void:
	#$AtkIndicator.visible = false;
	is_atking = false;
