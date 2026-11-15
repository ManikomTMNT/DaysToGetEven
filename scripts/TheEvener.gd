extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ENEMSPD = 100

var hp = 8000;
var gothit = false;
@export var isjmp = false;

var t = 200;

enum States {
	JUMP,
	THROW,
	IDLE
}

var even = States.IDLE
var time = 0;
var p = true;

const escenes = [preload("res://scene/Fire Enemy.tscn"), preload("res://scene/Shock Enemy.tscn"), preload("res://scene/Sword Enemy.tscn"), preload("res://scene/Punchenem.tscn")]

func ow(k):
	gothit = true;
	hp -= 10;

func _ready() -> void:
	$AtkArea.can_dmg = false;
	$AnimatedSprite2D.play("default");

func _physics_process(delta: float) -> void:
	var dir = 0
	$ProgressBar.value = hp
			
	if not is_on_floor():
		velocity += get_gravity() * delta

	if hp < 1:
		get_tree().change_scene_to_file("res://scene/Win.tscn");
		
	var player = get_tree().get_first_node_in_group("Player")
	
	if player:
		dir = position.direction_to(player.global_position)
	if player:
		if self.is_in_group("Boss"):
			time += 0.75;
			match even:
				States.IDLE:
					$AnimatedSprite2D.play("default")
					if time > 5:
						if is_on_floor():
							time = 0;
							even = randi_range(0,1)
				States.JUMP:
					$AnimatedSprite2D.play("default")
					velocity.y = -500
					velocity.x = sign(dir.x)*randi_range(-400,400)
					if is_on_floor():
						var pp = escenes[randi_range(0,3)].instantiate()
						pp.global_position = self.global_position + Vector2(50,50)
						get_tree().current_scene.add_child(pp)
						even = States.IDLE
				States.THROW:
					if p:
						time = 0
						$AnimatedSprite2D.play("throw")
					$AnimatedSprite2D.animation_finished.connect(func(): p = false)
					if (not p):
						time += 1;
						$bULLET.rotate(30)
						$bULLET.global_position = lerp($bULLET.global_position, player.global_position, 0.05)
						p = false
						if time > 30:
							$bULLET.position == Vector2(-51.0,1)
							even = States.IDLE
					
					
						
					
				
	if gothit:
		hp -= 10
		gothit = false
		velocity.x -= 100*sign(dir.x)

	if isjmp and is_on_floor():
		velocity.y = -100
	
	move_and_slide()
	
