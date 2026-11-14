extends Area2D

var dt = 0

@export var ismele = true
@export var atkrate = 15
var can_dmg = true;
# Called when the node enters the scene tree for the first time.
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
					body.ow(sign($"..".velocity.x))
			dt = 0
	
