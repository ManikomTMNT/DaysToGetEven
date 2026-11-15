extends CharacterBody2D



const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ENEMSPD = 300

@export var hp = 100;
var hh = 0;
var gothit = false;
@export var isjmp = false;
func _ready() -> void:
	$AnimatedSprite2D.play("default");

func ow(h):
	gothit = true;
	hp -= h;

func atkresponse():
	$AnimatedSprite2D.play("slash");

func _physics_process(delta: float) -> void:
	var dir = 0
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta



	if hp < 1:
		queue_free()
		
	var player = get_tree().get_first_node_in_group("Player")
	
	if player:
		dir = position.direction_to(player.global_position)
		velocity.x = dir.x * ENEMSPD
	
		if dir.x < 0:
			$AnimatedSprite2D.flip_h = true 
		else:
			$AnimatedSprite2D.flip_h = false

	
	if gothit:
		gothit = false
		velocity.x -= 300*sign(dir.x)

	if player:
		if isjmp and is_on_floor() and randi_range(0,10000) < 10000/2:
			velocity.y = -500
		
	move_and_slide()
	
