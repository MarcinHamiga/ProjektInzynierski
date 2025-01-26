extends Node

signal regenerate

var num_records: int = 1  
var records: Array[Dictionary] = []      
var task_list: Array[Dictionary] = []
var file_tasks: Array[Dictionary] = []  # Zadania plikowe
var server_tasks: Array[Dictionary] = []  # Zadania serwerowe
var current_id: int = 1   
var current_record_id: int = -1  
var required_answer: bool = false

const SERVER_ACCESS: String = "Dostęp do serwera"
const SOFTWARE_INSTALL: String = "Instalacja oprogramowania"

func _ready() -> void:
	pass

func load_and_generate_records() -> void:
	var data_file_path = "res://Dane/employee.json"  
	var itemData = load_json_file(data_file_path)

	var names = itemData["names"]
	var surnames = itemData["surnames"]
	var topics = itemData["topics"]
	var types = itemData["types"]
	var email = itemData["email"]
	var access = itemData["access"]

	records.clear()
	task_list.clear()
	for i in range(num_records):
		var name_index = randi() % names.size()
		var surname_index = randi() % surnames.size()
		var email_index = randi() % email.size()
		var access_index = randi() % access.size()

		var record = {
			"id": i + 1,
			"name": names[name_index] + " " + surnames[surname_index],
			"email": names[name_index] + "." + surnames[surname_index] + email[email_index],
			"access": access[access_index],
		}
		records.append(record)

		var topic_index = randi() % topics.size()
		var type_index = randi() % types.size()
		var task = {
			"employee_id": record["id"],
			"topic": topics[topic_index],
			"type": types[type_index],
		}
		task_list.append(task)

func process_tasks() -> void:
	file_tasks.clear()
	server_tasks.clear()
	for task in task_list:
		if task["type"] == self.SOFTWARE_INSTALL:
			print("if 1")
			var file_task_generator = preload("res://scripts/serwery_i_pliki/file_task_generator.gd").new()
			var random_data = file_task_generator.generate_random_data()

			if random_data.size() > 0:
				print("if1 / if 2")
				var file_info: Dictionary = random_data[0]  

				var installation_task: Dictionary = {
					"id": task["employee_id"],  
					"file_name": file_info["name"],
					"file_creator": file_info["creator"],
					"file_extension": file_info["extension"],
				}

				file_tasks.append(installation_task)
				print("file_tasks")
				print(file_tasks)
			else:
				print("Nie udało się wygenerować danych pliku dla zadania instalacji.")

		elif task["type"] == self.SERVER_ACCESS:
			print("else 1")
			var server_task_generator = preload("res://scripts/serwery_i_pliki/server_task_generator.gd").new()
			var random_data = server_task_generator.generate_random_server_task()

			if random_data.size() > 0:
				print("else 1/ if 1")
				var server_info = random_data[0]  

				var server_access_task: Dictionary = {
					"id": task["employee_id"],  
					"access_rank": server_info["access_rank"],
					"access_location": server_info["access_location"],
					"access_type": server_info["access_type"],
				}

				server_tasks.append(server_access_task)
				print("server_tasks")
				print(server_tasks)
			else:
				print("Nie udało się wygenerować danych serwera dla zadania dostępu.")

	current_id = -1


func set_current_id(record_id: int) -> void:
	current_record_id = record_id
	#print("Ustawiono current_record_id na:", current_record_id)

func get_current_id() -> int:
	return current_record_id

func load_json_file(file_path: String) -> Dictionary:
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		data_file.close()
		if parsed_result is Dictionary:
			return parsed_result
	return {}

func set_answer(answer) -> void:
	required_answer = answer

func get_answer() -> bool:
	return required_answer

func get_records() -> Array[Dictionary]:
	return records

func get_tasks() -> Array[Dictionary]:
	return task_list

func get_file_tasks() -> Array[Dictionary]:
	return file_tasks

func get_server_tasks() -> Array[Dictionary]:
	return server_tasks
