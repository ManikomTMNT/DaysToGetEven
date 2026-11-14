extends CharacterBody2D

@export var right_action = "left";

const SPEED = 15.0
const JUMP_VELOCITY = -400.0
const MAXSPD = 250

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
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis(right_action, "right")
	if direction:
		velocity.x = clamp(velocity.x, -MAXSPD, MAXSPD)
		velocity.x += direction*SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if ghit: 
		ghit = false 
		velocity.x = dhit*600	
	
	move_and_slide()
