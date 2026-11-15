extends CharacterBody2D

@onready var dash_timer = $DashTimer
@onready var hp_bar = $HPBar
@onready var canim = $AnimatedSprite2D

var SPEED = 40.0
var JUMP_VELOCITY = -1100.0
var DASH_SPEED = 900.0
var MAXSPD = 300
var enem_typeo = "none"
var hp = 200
var ghit = false
var dhit = 0
var tired = false
var dash_direction = Vector2.ZERO

enum AnimStates {
	ATK,
	JMP,
	FALL,
	MOV,
	IDLE
}
enum States {
	FIRE,
	ELECTRIC,
	SLASH,
	PUNCH,
	NORMAL
}
var anim = AnimStates.IDLE
var state = States.NORMAL
var dizz = false
var dirr = 0;
var timer = 0

func ow(di, sort, dmg):
	if state == States.NORMAL and not anim == AnimStates.ATK :
		hp -= dmg;
		dizz = true
		timer = 0
		match sort:
			"firebull":
				state = States.FIRE
			"shock":
				state = States.ELECTRIC
			"punch":
				state = States.PUNCH
			"sword":
				state = States.SLASH
			_:
				dizz = false
				state = States.NORMAL
	

func _ready():
	$SpurtA/AnimatedSprite2D.hide();

func _playermov(delta):
		
	
	if state == States.ELECTRIC:
		JUMP_VELOCITY = -1100
		MAXSPD = 600
		SPEED = 100
		DASH_SPEED = 1500
	else:		
		JUMP_VELOCITY = -1100
		SPEED = 50
		MAXSPD = 300
		DASH_SPEED = 900
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta * 3.5

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")

	if direction:
		velocity.x = clamp(velocity.x, -MAXSPD, MAXSPD)
		velocity.x += direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Attack collision position
	if Input.is_action_pressed("left"):
		$AtkCollisionBox.position.x = -73
		$AnimatedSprite2D.flip_h = true
		dirr = -1;
		
	elif Input.is_action_pressed("right"):
		$AtkCollisionBox.position.x = -28
		$AnimatedSprite2D.flip_h = false
		dirr = 1;

	if Input.is_action_pressed("up"):
		$AtkCollisionBox.position.y = -87
	else:
		$AtkCollisionBox.position.y = 0
		
	if not dizz:
		match anim:
			
			AnimStates.IDLE:
				$AnimatedSprite2D.play("idle")
				if not is_on_floor():
					anim = AnimStates.JMP
				if  Input.is_action_just_pressed("atk"):
					anim = AnimStates.ATK
				if  Input.is_action_pressed("left") or Input.is_action_pressed("right"):
					anim = AnimStates.MOV
			AnimStates.JMP:
				$AnimatedSprite2D.play("jump")
				if velocity.y >= 0:
					anim = AnimStates.FALL
				if  Input.is_action_just_pressed("atk"):
					anim = AnimStates.ATK
			AnimStates.FALL:
				$AnimatedSprite2D.play("fall")
				if Input.is_action_just_pressed("atk"):
					anim = AnimStates.ATK
				if is_on_floor():
					anim = AnimStates.IDLE
			AnimStates.MOV:
				$AnimatedSprite2D.play("walk")
				if velocity.x == 0:
					anim = AnimStates.IDLE
				if Input.is_action_just_pressed("atk"):
					anim = AnimStates.ATK
				if not is_on_floor():
					anim = AnimStates.JMP
			AnimStates.ATK:
				$AnimatedSprite2D.play("attack")
				$AnimatedSprite2D.animation_finished.connect(func():
					if not is_on_floor():
						anim = AnimStates.FALL
					else:
						anim = AnimStates.MOV
						)
	else:
		$AnimatedSprite2D.play("dizzy")
	
		
	if ghit:
		ghit = false
		velocity.x = dhit * 600
	
	move_and_slide()
	
func _physics_process(delta: float) -> void:	
	hp_bar.value = hp
	if hp < 200:
		hp += 1;
	
	print(hp)

	if hp < 0:
		queue_free()
	
	match state:
		States.NORMAL:
			_playermov(delta)
			dizz =false;
		States.FIRE:
			if dizz:
				_playermov(delta)
				timer += 1;
				if timer >= 80:
					dizz = false
			else:
				timer = 0
				$ExplosionArea.called = true
				$AnimatedSprite2D.scale = Vector2(2.13,2.13)
				$AnimatedSprite2D.play("explode")
				$AnimatedSprite2D.animation_finished.connect (func(): 
						$AnimatedSprite2D.scale = Vector2(0.77,0.77)
						state = States.NORMAL)
		States.ELECTRIC:			
			if dizz:
				_playermov(delta)
				timer += 1;
				if timer >= 0:
					dizz = false
			else:
				if timer < 100:
					$AnimatedSprite2D.self_modulate = Color(1, 1, 0);
					_playermov(delta)
					timer += 1
				else:
					$AnimatedSprite2D.self_modulate = Color(1, 1, 1);
					state = States.NORMAL
		States.PUNCH:
			if dizz:
				_playermov(delta)
				timer += 1;
				if timer >= 80:
					dizz = false	
			else:
				$PunchA.called = true;
				$AnimatedSprite2D.play("punched")
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.animation_finished.connect(func():
									state = States.NORMAL)
		States.SLASH:
			if dizz:
				_playermov(delta)
				timer += 1;
				if timer >= 80:
					dizz = false	
			else:
				$SpurtA/AnimatedSprite2D.show();
				$SpurtA.called = true;
				$AnimatedSprite2D.play("slashed")
				$AnimatedSprite2D.animation_finished.connect(func():				
									$SpurtA/AnimatedSprite2D.hide();
									state = States.NORMAL)
		_:
			state = States.NORMAL
			
	print(state);


	
