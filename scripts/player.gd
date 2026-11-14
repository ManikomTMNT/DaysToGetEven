extends CharacterBody2D

@export var left_action = "left";
@export var right_action = "right";
@export var up_action = "up";
@export var down_action = "down";
@export var jump_action = "jump";
@onready var dash_timer = $DashTimer
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

const DASH_SPEED = 900.0
var dash_direction = Vector2.ZERO
var is_dashing = false;
var can_dash = true;
func _physics_process(delta: float) -> void:
	if is_dashing:
		velocity = dash_direction * DASH_SPEED
		move_and_slide()
		return
	
	if hp < 1:
		queue_free()
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 3.5

	# Handle jump.
	if Input.is_action_just_pressed(jump_action) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis(left_action, right_action);
	
	if direction:
		velocity.x = clamp(velocity.x, -MAXSPD, MAXSPD)
		velocity.x += direction*SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_pressed(left_action):
		$AtkCollisionBox.position.x = -87
	elif Input.is_action_pressed(right_action):
		$AtkCollisionBox.position.x = 87
	else:
		$AtkCollisionBox.position.x = 0
	
	if Input.is_action_pressed(up_action):
		$AtkCollisionBox.position.y = -87;
	else:
		$AtkCollisionBox.position.y = 0;
	
	if Input.is_action_just_pressed("dash") and can_dash:
		is_dashing = true
		can_dash = false

		var input_dir = Vector2.ZERO

		input_dir.x = Input.get_axis(left_action, right_action)
		input_dir.y = Input.get_axis(up_action, down_action)

		if input_dir == Vector2.ZERO:
			input_dir.x = sign($AtkCollisionBox.position.x)

		dash_direction = input_dir.normalized()
		velocity = dash_direction * DASH_SPEED

		dash_timer.start()
	
	if !is_dashing and is_on_floor() and !can_dash:
		can_dash = true;
	
	if ghit: 
		ghit = false 
		velocity.x = dhit*600	
	
	move_and_slide()


func _on_dash_timer_timeout() -> void:
	is_dashing = false
	if is_on_floor():
		can_dash = true
