extends Node

var file_path = "res://Dane/servers.json"

func _ready() -> void:
	randomize()

func generate_random_server_task() -> Array:
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if file:
		var json_data = file.get_as_text()  
		var json_parser = JSON.new()
		var result = json_parser.parse(json_data)  
		
		if result == OK:
			var json_object = json_parser.get_data()
			
			var is_safe = randi_range(1, 100)
			#print("is_safe: %d" % [is_safe])
			var task = {}
			if is_safe >= 50:
				task = get_random_task(json_object["safe"])
				main_sip.set_answer(true)
			else:
				task = get_random_task(json_object["notsafe"])
				main_sip.set_answer(false)

			var server_task = {
				"access_rank": task["access_rank"],
				"access_location": task["access_location"],
				"access_type": task["access_type"]
			}

			return [server_task]
		else:
			print("Błąd parsowania JSON:", json_parser.get_error_message())
			return []  
	else:
		print("Błąd otwarcia pliku:", file_path)
		return []  

func get_random_task(task_list: Array) -> Dictionary:
	if task_list.size() > 0:
		return task_list[randi() % task_list.size()] 
	else:
		return {}
