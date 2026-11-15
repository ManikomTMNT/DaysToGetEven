extends Area2D

signal Atk

var i = 0;
var is_atking = false;
@export var dmg = 0;
@export var isjk = false;
var called = false;
var pdmg = 1;

func check_coll(body: Node2D) -> void:
	if is_atking && body.is_in_group("Enemy"):
		body.ow(dmg)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isjk:
		if Input.is_action_just_pressed("atk") and not  $"..".dizz and ($"..".state == $"..".States.NORMAL) or ($"..".state == $"..".States.ELECTRIC):
			if $"..".state == $"..".States.ELECTRIC:
				pdmg = dmg
				dmg = 20
			else: 
				dmg = pdmg
			is_atking = true;
			#$AtkIndicator.visible = true;
			$Timer.wait_time = 0.2;
			$Timer.start();
			
		if Input.is_action_just_pressed("dash") and not  $"..".dizz and ($"..".state == $"..".States.NORMAL) or ($"..".state == $"..".States.ELECTRIC):
			var koo = get_overlapping_bodies()
			for body in koo:
				if body.is_in_group("Enemy"):
					pass
	else:
		if called:
			is_atking = true;
			called = false
			i += 1;
			#$AtkIndicator.visible = true;
			$Timer.wait_time = 0.2;
			$Timer.start();
		else:
			is_atking = false;
			

	var koo = get_overlapping_bodies()
	for body in koo:
		check_coll(body)


func _on_timer_timeout() -> void:
	#$AtkIndicator.visible = false;
	is_atking = false;
