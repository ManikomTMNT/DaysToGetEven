extends CharacterBody2D


const SPEED = 200;

var hp = 100;
var gothit = false;
var direction = Vector2(0, 0);
var d = 0;

func ow():
	gothit = true;

func _ready():
	$ShootTimer.start()

@export var bullet_scene: PackedScene = preload("res://scene/EnemyBullet.tscn");
@onready var shoot_timer = $ShootTimer;

func _physics_process(delta: float) -> void:
	velocity = direction * SPEED;

	direction.x = sin(d) * 2;
	direction.y = cos(d) * 2;
	
	d += 0.05;
	
	if hp < 1:
		queue_free()
		
	var player = get_tree().get_first_node_in_group("Player")	
	
	if gothit:
		hp -= 10
		gothit = false
	
	move_and_slide()
	


func _on_shoot_timer_timeout() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position;
	bullet.direction = Vector2.RIGHT.rotated(randf() * TAU)
	bullet.rotation = bullet.direction.angle();
	
	get_tree().current_scene.add_child(bullet)
