extends Node

var num_records := 4  # Liczba rekordów
var records = []      # Lista przechowująca dane pracowników
var task_list = []    # Lista przechowująca dane zadań

func _ready() -> void:
	load_and_generate_records()  # Załaduj dane i wygeneruj rekordy
 
func load_and_generate_records():
	if records.size() > 0:
		return  # Nie generuj ponownie, jeśli dane już istnieją

	var data_file_path = "res://Dane/employee.json"  # Ścieżka do pliku JSON
	var itemData = load_json_file(data_file_path)

	# Uzupełnienie list z pliku JSON
	var names = itemData["names"]
	var surnames = itemData["surnames"]
	var topics = itemData["topics"]
	var types = itemData["types"]
	var email = itemData["email"]
	var access = itemData["access"]

	# Generowanie pracowników
	records.clear()
	task_list.clear()
	for i in range(num_records):
		# Losowanie danych dla pracownika
		var name_index = randi() % names.size()
		var surname_index = randi() % surnames.size()
		var email_index = randi() % email.size()
		var access_index = randi() % access.size()

		# Dodanie pracownika do listy `records`
		var record = {
			"id": i + 1,
			"name": names[name_index] + " " + surnames[surname_index],
			"email": names[name_index] + "." + surnames[surname_index] + email[email_index],
			"access": access[access_index],
		}
		records.append(record)

		# Losowanie zadania dla pracownika
		var topic_index = randi() % topics.size()
		var type_index = randi() % types.size()
		var task = {
			"employee_id": record["id"],
			"topic": topics[topic_index],
			"type": types[type_index],
		}
		task_list.append(task)

func load_json_file(file_path: String) -> Dictionary:
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		data_file.close()
		if parsed_result is Dictionary:
			return parsed_result
	return {}

func get_records() -> Array:
	return records

func get_tasks() -> Array:
	return task_list
