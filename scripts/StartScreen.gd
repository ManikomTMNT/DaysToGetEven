extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	$Fade.fade_out()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	Globali.selected_char_id = $OptionButton.get_selected_id();
	print(Globali.selected_char_id)
	get_tree().change_scene_to_file("res://scene/main.tscn");
