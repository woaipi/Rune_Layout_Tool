class_name RoadFind
extends Node

var target_position_grid:Vector2i	##目的地坐标（grid）
var unit_position_grid:Vector2i		##单位坐标（grid）
var block_size:int = 32				##区块大小（grid）
var grid_size:int = 128				##方格大小（pixel）
var pixel_to_block:int				##像素转区块坐标

var open_set:Array					##开放集
var road_final:Array				##路线回溯数组（从终点往起点）
var came_from:Array					##路线回溯数组（从起点往终点）

var g_score:Dictionary				##自起点移动到该单元格成本g_score
var g_score_self:Dictionary			##单元格自己的移动成本g_score_self
var f_score:Dictionary				##单元格到目的地的总函数f_score = g_score+ h_n
var come_cell:Dictionary		##记录进入该单元格的上一个单元格坐标，key=本格坐标，value = 进入格坐标
var move_dir_array:Array =[
	Vector2i(-1, 0), Vector2i(-1, -1),
	Vector2i(0, -1), Vector2i(1, -1),
	Vector2i(1, 0), Vector2i(1, 1),
	Vector2i(0, 1), Vector2i(-1, 1)
]

var block_manager					##组内成员block_manager(后期可能会将block_manager与区块随机生成与该脚本三合一，暂时使用)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InputMonitor.mouse_position.connect(get_mouse_position_signal)
	pixel_to_block = block_size * grid_size
	var temp = get_tree().get_nodes_in_group("block&grid&roadfind")
	for i in temp:
		if i.name =="BlockManager":
			block_manager = i
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

##单位方格坐标转录
func get_unit_position_grid(position_in:Vector2)->void:
	var unit_position = position_in
	unit_position_grid = floor(unit_position)
	pass

##鼠标标定目的地方格坐标转录
func get_mouse_position_signal(target_position_input:Vector2)->void:
	var target_position = target_position_input
	target_position_grid = floor(target_position/grid_size)

##预期成本h(n)
func h_n(cell_input:Vector2i)->float:
	var length_x = cell_input.x - target_position_grid.x
	var length_y = cell_input.y - target_position_grid.y
	return abs(length_x ** 2 + length_y ** 2)

##邻居方格返回
func find_neighbor(center_cell:Vector2i)->Array:
	var return_array:Array
	for i in move_dir_array:
		return_array.append(center_cell + i)
	return return_array

##按照属性添加格子
func calculate_cost_dict(cell_input:Vector2i, come_cell_input:Vector2i)->void:
	var h_n_temp = h_n(cell_input)
	if not g_score_self.has(cell_input):
		g_score_self[cell_input] = get_g_score(cell_input)
	
	var g_score_temp:float = g_score_self[cell_input] +g_score[come_cell_input]
		##判断新g_score是否优于旧g_score
	if g_score.has(cell_input) and g_score_temp >= g_score[cell_input]:
		pass
	else:
		g_score[cell_input]= g_score_temp
		come_cell[cell_input] = come_cell_input
		f_score[cell_input] = g_score[cell_input] + h_n_temp
		if not open_set.has(cell_input):
			open_set.append(cell_input)
			
##开放集添加单位格
func open_set_add(cell_input: Vector2i)->void:
	var neighbor = find_neighbor(cell_input)
	for i in neighbor:
		calculate_cost_dict(i, cell_input)
	pass
	
##查找指定方格的g_score
func get_g_score(cell_input:Vector2i)->float:
	var block_cell = Vector2i(floor(cell_input.x/block_size), floor(cell_input.y/block_size))
	var grid_cell_in_block = Vector2i(cell_input.x%block_size, cell_input.y%block_size)
	var return_value:float

	if block_cell in block_manager.last_preloaded_block_array:
		var block_find = block_manager.get_node(str(block_cell))
		return_value = block_find.get_grid_g_score(grid_cell_in_block)
		pass
	else:
		ErrorLog.error_warning_record(ErrorLog.ERR.ROADFIND, "对应区块未被加载或预加载")
		return_value = INF
	return return_value

##a*启动函数
func a_star_init()->void:
	g_score_self[unit_position_grid] = get_g_score(unit_position_grid)
	g_score[unit_position_grid] = g_score_self[unit_position_grid]
	f_score[unit_position_grid] = g_score[unit_position_grid] + h_n(unit_position_grid)
	come_cell[unit_position_grid] = null
	open_set.append(unit_position_grid)

##找出开放集中f_score最小的方格坐标（null表示出错）
func find_f_score_min_in_openset()->Variant:
	var f_score_min = INF
	var return_cell:Variant
	var is_find:bool = false
	
	for i in open_set:
		if f_score[i]< f_score_min:
			f_score_min = f_score[i]
			return_cell = i
			is_find = true
	if is_find:
		open_set.erase(return_cell)
	else:
		ErrorLog.error_warning_record(ErrorLog.ERR.ROADFIND,"find_f_score_min_in_openset wrong!open_set = "+str(open_set))
		return_cell = null
	
	return return_cell

##a*运行框架
func a_star_roadfind()->void:
	a_star_init()
	var stage = 1
	##a*主循环
	while stage == 1:
		stage = a_star_loop()
		##跳出a*主循环，进入下一阶段处理
		if stage == 0:break
		##异常返回，处理待定
		elif stage == null:
			ErrorLog.error_warning_record(ErrorLog.ERR.ROADFIND, "a_star_roadfind err,a_star_loop returns INF")
			break
	##a*确认最终路线	
	stage = 1
	while stage == 1:
		stage = final_check()
		pass
	##a*路线回正
	pass

##a*主循环
func a_star_loop()->Variant:
	var judged_grid = find_f_score_min_in_openset()
	var return_value:Variant
	
	if judged_grid == target_position_grid:
		return_value = 0
	##异常处理
	elif judged_grid == null:
		ErrorLog.error_warning_record(ErrorLog.ERR.ROADFIND, "a_star_loop ，judged_grid异常")
		return_value = null
	else:
		open_set_add(judged_grid)
		return_value = 1
	return return_value

##路线的最后检查
func final_check()->int:
	var path:Vector2i = target_position_grid
	while come_cell.has(path):
		road_final.append(path)
		if path != unit_position_grid:
			path = come_cell[path]
		else:break
	road_final.reverse()
	road_final.pop_front()
	return 0

	
