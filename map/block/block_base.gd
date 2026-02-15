class_name BlockBaseClass
extends TileMapLayer

@export var block_size:int
@export var grid_size:int 
@export var random_seed:int
@export var block_coordinates:Vector2i

var grid_speed_dict_array:Array


func _ready() -> void:
	
	Roadfind.need_coordinates_g_score.connect(get_grid_g_score)

# Called when the node enters the scene tree for the first time.
##区块初始化函数
func init(block_size_input:int, grid_size_input:int, random_seed_input, block_coordinates_input:Vector2)->void:
	block_size = block_size_input
	grid_size = grid_size_input
	random_seed = random_seed_input
	block_coordinates = block_coordinates_input
	block_random_initialization()
	print(block_size, grid_size, block_coordinates)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#block_random_initialization()
	pass

##区块内地形生成用噪音函数
func block_random_initialization()->void:
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.seed = random_seed
	noise.fractal_lacunarity = 2
	noise.frequency = 0.05
	var world_coordinates = block_coordinates * block_size
	for i in range(block_size):
		for j in range(block_size):
			var temp = noise.get_noise_2dv(Vector2i(i, j)+world_coordinates)
			var grid_type
			if temp<0:
				grid_type = Vector2i(2, 0)
			elif temp>=0 and temp<0.1:
				grid_type = Vector2i.ZERO
			else:
				grid_type = Vector2i(1, 0)
				pass
			set_cell(Vector2i(i, j), 2, grid_type, 0)
			pass
	pass

##获取方格的g_score（临时使用，后期可能会换）
func get_grid_g_score(coordinates:Vector2i)->int:
	var temp = get_cell_tile_data(coordinates)
	var return_value = temp.get_custom_data("g_score")
	return return_value

func placeholder()->void:pass
