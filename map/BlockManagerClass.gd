class_name BlockManagerClass
extends Node2D

var camera_position:Vector2			##相机位置
var last_camera_position:Vector2	##上一次记录的相机位置
var block_preload_dict:Dictionary	##预加载区块字典
var last_preloaded_block_array:Array##上一次预加载区块
var random_seed

@export var sight_radius_block:int	##视野预加载区块
@export var block_size:int = 32		##区块大小（方格制）
@export var grid_size:int = 128		##方格大小（像素制）

var world_coordinates_grid:Vector2	##世界全局坐标(方格)
var world_coordinates_block:Vector2	##世界全局坐标(区块)

signal camera_move()				##相机跨区块发出信号
#signal return_g_score(g_score:int)	##返回g_score

func _ready() -> void:
	random_seed = 123456
	get_camera_block_coordinates()
	last_camera_position = camera_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_camera_block_coordinates()
	is_camera_move()

##静态函数像素坐标转方格坐标（待废弃）
static func pixel_position_to_grid(pixel_position_input:Vector2, grid_size_input:int)->Vector2i:
	return Vector2i(floor(pixel_position_input.x/grid_size_input), floor(pixel_position_input.y/grid_size_input))
##静态函数方格坐标转区块坐标
static func grid_position_to_block(grid_position_input:Vector2, block_size_input:int)->Vector2i:
	return Vector2i(floor(grid_position_input.x/block_size_input), floor(grid_position_input.y/block_size_input))

##添加预加载区块坐标到预加载数组
func add_preload_block_to_array()->Array:
	var preload_block_array:Array
	for i in range(camera_position.x-sight_radius_block, camera_position.x +sight_radius_block):
		for j in range(camera_position.y-sight_radius_block, camera_position.y + sight_radius_block):
			preload_block_array.append(Vector2i(i, j))
	return preload_block_array
	
##获取相机区块坐标
func get_camera_block_coordinates()->void:
	var temp = $"../Camera2D".global_position
	camera_position = grid_position_to_block(pixel_position_to_grid(temp, grid_size), block_size)
	pass

##相机跨区块判断
func is_camera_move()->void:
	if camera_position != last_camera_position:
		camera_move.emit()
		last_camera_position = camera_position
	pass

##相机跨区块时动态添加和卸载对应区块，并且做坐标组更新
func _on_camera_move() -> void:
	var add_node_array = add_preload_block_to_array()
	for i in last_preloaded_block_array:
		if i not in add_node_array:
			if self.has_node(str(i)):
				var remove_node = self.get_node(str(i))
				remove_node.queue_free()
				
	for i in add_node_array:
		if not self.has_node(str(i)):
			var new_node = preload("res://map/block/block_base.tscn").instantiate()
			self.add_child(new_node)
			new_node.init(block_size, grid_size, random_seed, Vector2i(i))
			new_node.name = str(i)
			new_node.position = grid_size *block_size *i
	last_preloaded_block_array = add_node_array
	ErrorLog.err_log_save(str(last_preloaded_block_array))
	pass # Replace with function body.

##对应区块预加载？传入区块内方格坐标；返回-1
func find_block_loaded(coordinates_block:Vector2i, coordinates_grid:Vector2i)->int:
	var return_value:int
	if coordinates_block not in last_preloaded_block_array:
		ErrorLog.error_warning_record(ErrorLog.ERR.ROADFIND, "寻路未找到指定区块"+str(coordinates_block))
	else:
		var temp = get_node(str(coordinates_block))
		return_value = temp.get_grid_g_score(coordinates_grid)
	return return_value
	
	
