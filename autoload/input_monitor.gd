class_name InputMonitorClass
extends Node2D

var zoom_min:float
var zoom_max:float
var zoom:float

var move_dir:Vector2# 这个变量也可以完全私有，通过信号传递

var _w_pressed:bool
var _a_pressed:bool
var _s_pressed:bool
var _d_pressed:bool
var is_move_signal_emit:bool

var _mouse_button_left:bool
var _mouse_button_right:bool

signal camera_move(move_dir:Vector2)
signal zoom_emit(zoom_out:Vector2)
signal mouse_position(position:Vector2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_w_pressed = false
	_a_pressed = false
	_s_pressed = false
	_d_pressed = false
	
	
	zoom_min = 0.5
	zoom_max = 2.0
	zoom = 1
	
	
	is_move_signal_emit = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#check_signal_emit()
	#cycle_end_signal_emit()
	#cycle_end_process()
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey and not event.echo:
		var pressed = event.pressed
		match event.keycode:
			KEY_W:_w_pressed = pressed
			KEY_A:_a_pressed = pressed
			KEY_S:_s_pressed = pressed
			KEY_D:_d_pressed = pressed
			_:return
		update_move_dir()
		
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		match mouse_event.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				zoom *=1.1
			MOUSE_BUTTON_WHEEL_DOWN:
				zoom *=0.9
			_:return
		zoom = clamp(zoom, zoom_min, zoom_max)
		zoom_emit.emit(Vector2(zoom, zoom))
		
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		var pressed = event.pressed
		match mouse_event.button_index:
			MOUSE_BUTTON_LEFT:return 
			MOUSE_BUTTON_RIGHT:return_mouse_position_grid()
			_:return 
		

func update_move_dir()->void:
	var dir_temp = Vector2.ZERO
	dir_temp.x = (1 if _d_pressed else 0) - (1 if _a_pressed else 0)
	dir_temp.y = (1 if _s_pressed else 0) - (1 if _w_pressed else 0)
	move_dir = dir_temp.normalized()
	camera_move.emit(move_dir)
	pass

func return_mouse_position_grid()->void:
	var temp = get_global_mouse_position()
	mouse_position.emit(temp)
	pass
	
	
	
	
