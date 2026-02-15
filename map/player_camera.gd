class_name CameraBase
extends Camera2D

@export var move_speed_grid:int = 10##相机移动速度（方格）
@export var zoom_min:Vector2		##缩放上限
@export var zoom_max:Vector2		##缩放下限

var grid_size:int					##方格大小
var move_dir = Vector2.ZERO			##相机移动方向
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InputMonitor.camera_move.connect(keyboard_input_signal_in)
	InputMonitor.zoom_emit.connect(mouse_wheel_signal_in)
	grid_size = $"../BlockManager".grid_size
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#get_input_Mouse_and_Keyboard()
	global_position += move_dir * get_move_speed_grid()*delta
	pass

##相机移动速度设定（跨方格移动速度*方格单位大小）
func get_move_speed_grid()->int:
	return move_speed_grid*grid_size

##相机移动方向信号接收与转录
func keyboard_input_signal_in(move_dir_in)->void:
	print(move_dir_in)
	move_dir = move_dir_in
	pass
##相机缩放信号接收与转录
func mouse_wheel_signal_in(zoom_in:Vector2)->void:
	self.zoom = zoom_in
	pass
