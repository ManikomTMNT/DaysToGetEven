extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ENEMSPD = 100

var hp = 100;
var gothit = false;
@export var isjmp = false;

func ow():
	gothit = true;

func _physics_process(delta: float) -> void:
	var dir = 0
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if isjmp and randi_range(0,100) > 50 and is_on_floor():
		velocity.y = 50

	if hp < 1:
		queue_free()
		
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		dir = position.direction_to(player.global_position)
		velocity.x = dir.x * ENEMSPD
		
	if gothit:
		hp -= 10
		gothit = false
		velocity.x -= 1000*sign(dir.x)
	
	move_and_slide()
	
