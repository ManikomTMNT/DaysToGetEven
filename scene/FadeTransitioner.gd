extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var anim_player = $ColorRect/AnimationPlayer

func _ready() -> void:
	color_rect.visible = false

func fade_in() -> void:
	color_rect.visible = true
	anim_player.play("fadein")
	await anim_player.animation_finished
	color_rect.visible = false

func fade_out() -> void:
	color_rect.visible = true
	anim_player.play("fadeout")
	await anim_player.animation_finished
