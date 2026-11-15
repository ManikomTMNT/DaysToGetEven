extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ENEMSPD = 200

var hp = 100;
var gothit = false;
@export var isjmp = false;

var t = 200;
var tt = 0;
func ow(k):
	hp -= k;
	gothit = true;

func _ready() -> void:
	$ShockSprite.visible = false;
	$AtkArea.can_dmg = false;
	$AnimatedSprite2D.play("default");

func _physics_process(delta: float) -> void:
	var dir = 0
	print(hp);

	if hp < 1:
		queue_free()
		
	var player = get_tree().get_first_node_in_group("Player")
	
	if player:
		dir = position.direction_to(player.global_position)
		velocity = dir * ENEMSPD
		for i in get_slide_collision_count():
			var collision := get_slide_collision(i)
			var collider := collision.get_collider()
			if collider:
				tt += 1;
				if tt > 10:
					tt = 0
					if collider.is_in_group("Player"):
						queue_free()
	if gothit:
		gothit = false
		velocity.x -= 300*sign(dir.x)


	if isjmp and is_on_floor():
		velocity.y = -100
	
	move_and_slide()
	

func _on_shock_timer_timeout() -> void:
	$AtkArea.can_dmg = true;
	$ShockVisTimer.start()
	$AnimatedSprite2D.play("shock");


func _on_shock_vis_timer_timeout() -> void:
	$AtkArea.can_dmg = false;
	$AnimatedSprite2D.play("default");
