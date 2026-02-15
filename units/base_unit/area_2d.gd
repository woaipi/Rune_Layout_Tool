class_name base_box
extends Area2D

signal unit_clicked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		unit_clicked.emit()
	pass # Replace with function body.
