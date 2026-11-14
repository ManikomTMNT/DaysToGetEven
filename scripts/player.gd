extends CharacterBody2D

@export var left_action = "left";
@export var right_action = "right";
@export var up_action = "up";
@export var jump_action = "jump";

const SPEED = 40.0
const JUMP_VELOCITY = -1100.0
const MAXSPD = 300

var hp = 100
var ghit = false 
var dhit = 0


func ow(di):
	ghit = true
	hp = hp - 30
	dhit = di


func _physics_process(delta: float) -> void:
	if hp < 1:
		queue_free()
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 3.5

	# Handle jump.
	if Input.is_action_just_pressed(jump_action) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis(left_action, right_action);
	if direction:
		velocity.x = clamp(velocity.x, -MAXSPD, MAXSPD)
		velocity.x += direction*SPEED
		
		if direction < 0:
			$AtkCollisionBox.position.x = -87
		elif direction > 0:
			$AtkCollisionBox.position.x = 87
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if ghit: 
		ghit = false 
		velocity.x = dhit*600	
	
	move_and_slide()
