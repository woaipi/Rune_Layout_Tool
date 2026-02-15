class_name base_unit
extends Node2D

var x:int
var y:int
var move_speed:float = 100
var move_dir = Vector2.ZERO
var next_task:Dictionary

signal task_list_initial

func _ready() -> void:
	task_list_initial.emit()
 # Replace with function body.

func _process(delta: float) -> void:
	global_position += move_dir * move_speed * delta


func wander(rand_dir:int)->void:
	var timer_temp:Timer
	match(rand_dir):
		0:move_dir = Vector2(1, 0)
		1:move_dir = Vector2(1, 1)
		2:move_dir = Vector2(0, 1)
		3:move_dir = Vector2(-1, 1)
		4:move_dir = Vector2(-1, 0)
		5:move_dir = Vector2(-1, -1)
		6:move_dir = Vector2(0, -1)
		7:move_dir = Vector2(1, -1)
		
func move_to_specified_location(location_input:Vector2)->void:
	#var self_position_grid = 
	pass
	
	
func _on_task_list_task_dict_return(task: Dictionary) -> void:
	#print("base_unit _on_timer_timeout")
	next_task = task
	print("next_task = ",next_task)
	$Timer_list/Timer.wait_time = next_task["duration"]
	$Timer_list/Timer.start()
	task_match(next_task["task_name"])
# Replace with function body.

func task_match(task_name_input:String)->void:
	#print("base_unit task_match")
	match task_name_input:
		"wander":
			wander(randi_range(0, 7))
			pass
		"daze":
			daze()
			pass
		"be_clicked":
			be_clicked()
			pass
		"initial":
			pass
	pass

func be_clicked()->void:
	print("be_clicked")

	
func daze()->void:
	move_dir = Vector2.ZERO
	print("daze")



func path_finding()->void:
	pass


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
