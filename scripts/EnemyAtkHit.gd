extends Area2D

var dt = 0

@export var ismele = true
@export var atkrate = 15
var can_dmg = true;
@export var sort = "none";

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_dmg:
		var over = get_overlapping_bodies()
		if ismele:
			dt += 1;
		if (dt > atkrate):
			for body in over:
				if body.is_in_group("Player"):
					body.ow(sign($"..".velocity.x), sort)
					if get_parent().has_method("atkresponse"):
						get_parent().atkresponse();
			dt = 0
	
