class_name BaseMapClass
extends Node2D

@export var Is_Debug:bool
#var debug_button_path
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#debug_button_path = $Camera2D/Button
	Is_Debug = false
	#debug_button_path.show()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Is_Debug:
		pass
	pass


func _on_debug_button_pressed() -> void:
	if Is_Debug:
		Is_Debug = false
	else:
		Is_Debug = true
	pass # Replace with function body.

func add_base_unit_onclicked()->void:
	var add_child_scene = preload("res://units/base_unit/base_unit.tscn")
	$UnitPool.add_child(add_child_scene)
	
	pass
