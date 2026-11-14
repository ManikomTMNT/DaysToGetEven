extends CharacterBody2D

@onready var dash_timer = $DashTimer
@onready var hp_bar = $HPBar
@onready var anim = $AnimatedSprite2D

const SPEED = 40.0
const JUMP_VELOCITY = -1100.0
const DASH_SPEED = 900.0
var electric = false;
var MAXSPD = 300
var attacking = false
var enem_typeo = "none"
var hp = 100
var ghit = false
var dhit = 0
var tired = false
var dash_direction = Vector2.ZERO
var is_dashing = false
var can_dash = true
var exploding = false 

func ow(di, sort):
	if !tired:
		ghit = true
		hp -= 10
		dhit = di
		hp_bar.value = hp
		tired = true
		enem_typeo = sort
		anim.play("dizzy")
		$DizzyTimer.start()


func _ready():
	hp_bar.max_value = 100
	hp_bar.value = hp


func _physics_process(delta: float) -> void:

	if hp < 1:
		anim.play("fall")
		queue_free()
		return

	if is_dashing:
		velocity = dash_direction * DASH_SPEED
		move_and_slide()
		return

	if tired or electric:
		MAXSPD = 600
	else:
		MAXSPD = 300

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta * 3.5

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("jump")

	var direction := Input.get_axis("left", "right")

	if direction:
		velocity.x = clamp(velocity.x, -MAXSPD, MAXSPD)
		velocity.x += direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Attack collision position
	if Input.is_action_pressed("left"):
		$AtkCollisionBox.position.x = -87
	elif Input.is_action_pressed("right"):
		$AtkCollisionBox.position.x = 87
	else:
		$AtkCollisionBox.position.x = 0

	if Input.is_action_pressed("up"):
		$AtkCollisionBox.position.y = -87
	else:
		$AtkCollisionBox.position.y = 0

	# Dash
	if Input.is_action_just_pressed("dash") and can_dash:
		is_dashing = true
		can_dash = false

		var input_dir = Vector2.ZERO
		input_dir.x = Input.get_axis("left", "right")
		input_dir.y = Input.get_axis("up", "down")

		if input_dir == Vector2.ZERO:
			input_dir.x = sign($AtkCollisionBox.position.x)

		if input_dir == Vector2.ZERO:
			input_dir = Vector2.RIGHT

		dash_direction = input_dir.normalized()
		velocity = dash_direction * DASH_SPEED

		dash_timer.start()

	if !is_dashing and is_on_floor() and !can_dash:
		can_dash = true

	if ghit:
		ghit = false
		velocity.x = dhit * 600

	move_and_slide()

	# Anim
	
	$AnimatedSprite2D.self_modulate = Color(1,1,1);
	if electric:
		$AnimatedSprite2D.self_modulate = Color(1, 1, 0);
	
	if attacking:
		pass

	elif tired:
		if anim.animation != "dizzy":
			anim.play("dizzy")

	elif !is_on_floor():
		if velocity.y > 0:
			if anim.animation != "fall":
				anim.play("fall")
		else:
			if anim.animation != "jump":
				anim.play("jump")

	elif abs(velocity.x) > 5:
		if anim.animation != "walk":
			anim.play("walk")

	else:
		if anim.animation != "idle":
			anim.play("idle")

	# Flip sprite based on direction
	if velocity.x != 0:
		anim.flip_h = velocity.x < 0


func _on_dash_timer_timeout() -> void:
	is_dashing = false
	if is_on_floor():
		can_dash = true

func atk():
	if attacking or tired:
		return

	attacking = true
	anim.play("attack")

func _on_dizzy_timer_timeout() -> void:
	if tired:
		if enem_typeo == "shock":
			electric = true;
		if enem_typeo == "firebull":
			explode();

		tired = false
		anim.play("idle")

func explode():
	exploding = true;
	anim.play("explode")

	await anim.animation_finished

	for enemy in $ExplosionArea.get_overlapping_bodies():
		if enemy.is_in_group("enemy"):
			enemy.ow()

	attacking = false
	exploding = false;
	anim.play("idle")

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "attack":
		attacking = false
	$AbilityTimer.start()


func _on_ability_timer_timeout() -> void:
	electric = false;
