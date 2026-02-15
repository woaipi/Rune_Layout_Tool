class_name tasks_list
extends Node2D

var tasks_array:Array = ["wander","daze", "be_clicked"]
var last_task_id:int 

var regular_queue:Array
var emergency_queue:Array

var task_in_progress:Dictionary
signal task_dict_return(task:Dictionary)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print("tasks_list _ready")
	last_task_id = 0
	pass # Replace with function body.
#
func _process(delta:float)->void:
	if emergency_queue.is_empty():
		if regular_queue.is_empty():
			var i = randi_range(1, 5)
			print(i)
			if i == 5:
				tasks_add(1)
				pass
			else:
				tasks_add(0)
				pass
		
		pass
	elif task_in_progress["task_urgency"]>emergency_queue[0]["task_urgency"]:
		$"../Timer_list/Timer".stop()
		task_in_progress = emergency_queue.pop_front()
		task_return(task_in_progress)
	pass

func tasks_add(task_input)->void:
	#print("tasks_list tasks_add")
	match task_input:
		0:
			regular_queue.append({
				"task_name":"wander",
				"duration":1,
				"task_urgency":2,
				"task_id":0
			})
			pass
		1:
			regular_queue.append({
				"task_name":"daze",
				"duration":5,
				"task_urgency":2,
				"task_id":1
			})
			pass
		2:
			emergency_queue.append({
				"task_name":"be_clicked",
				"duration":1, 
				"task_urgency":1,
				"task_id":2
			})
			pass
	pass

func task_return(return_task:Dictionary)->void:
	#print("tasks_list task_return")
	task_dict_return.emit(return_task)
	pass

func _on_timer_timeout() -> void:
	#print("tasks_list _on_timer_timeout")
	if emergency_queue.is_empty():
		if regular_queue.is_empty():
			pass
		else:
			task_in_progress = regular_queue.pop_front()
	else:
		task_in_progress = emergency_queue.pop_front()
	task_return(task_in_progress)
	pass # Replace with function body.

func _on_base_unit_task_list_initial() -> void:
	#print("tasks_list _on_base_unit_task_list_initial")
	tasks_add(0)
	pass # Replace with function body.
	
func _on_area_2d_unit_clicked() -> void:
	tasks_add(2)
	pass # Replace with function body.
