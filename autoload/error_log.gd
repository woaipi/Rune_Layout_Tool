class_name ErrorLogClass
extends Node

var game_time:float
var error_and_warning_arr:Array
var system_date_dict:Dictionary
var game_start_date:String
var error_log_title:String
const ERROR_LOG_DIR_PATH = "user://error_log/"
enum ERR{
	UNIT_ERROR,				##单位错误
	INPUT_ERROR,			##输入错误
	INTERFACE_CHANGE_ERROR, ##？？？
	ROADFIND,				##寻路错误
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_time = 0.0
	error_and_warning_arr = []
	system_date_dict = Time.get_date_dict_from_system()
	game_start_date = str(system_date_dict["year"])+"_"+str(system_date_dict["month"])+"_"+str(system_date_dict["day"])
	error_log_title = game_start_date+".txt"
	print(error_log_title)
	first_create_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_pass_by(delta)
	pass

func time_pass_by(delta:float)->void:
	game_time += delta 
	pass

func error_warning_record(err_type:ERR, err_msg:String)->void:
	var temp_dict = {
		"err_type": err_type, 
		"err_msg": err_msg,
		"game_time":game_time
	}
	error_and_warning_arr.append(temp_dict)
	pass
	
func err_log_save(error_msg:String)->void:
	var error_log = FileAccess.open(ERROR_LOG_DIR_PATH+error_log_title, FileAccess.READ_WRITE)

	if error_log == null:
		var err_code = FileAccess.get_open_error()
		print(err_code)
	else:
		error_log.seek_end()
		error_log.store_string(error_msg+"\n")
		error_log.flush()

func first_create_game()->void:
	if not DirAccess.dir_exists_absolute(ERROR_LOG_DIR_PATH):
		DirAccess.make_dir_recursive_absolute(ERROR_LOG_DIR_PATH)
	else:
		FileAccess.open(ERROR_LOG_DIR_PATH+error_log_title, FileAccess.WRITE)
		print("Error_log_dir found")
		pass
