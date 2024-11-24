extends Node

# Liczba rekordów
var num_records := 4  
var records = []      
var task_list = []    
var file_tasks = []
var current_id := 1   
var current_record_id: int = -1  

# Funkcja _ready - inicjalizacja
func _ready() -> void:
	load_and_generate_records()  # Załaduj dane i wygeneruj rekordy
	process_tasks()  # Procesujemy zadania po załadowaniu danych

# Funkcja ładująca dane i generująca rekordy
func load_and_generate_records():
	if records.size() > 0:
		return  # Nie generuj ponownie, jeśli dane już istnieją

	# Ścieżka do pliku JSON
	var data_file_path = "res://Dane/employee.json"  
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
		var name_index = randi() % names.size()
		var surname_index = randi() % surnames.size()
		var email_index = randi() % email.size()
		var access_index = randi() % access.size()

		# Dodanie pracownika do listy
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

# Funkcja przetwarzająca zadania
func process_tasks():
	# Przechodzimy przez wszystkie zadania
	for task in task_list:
		if task["type"] == "Instalacja oprogramowania":
			# Generowanie zadania dla instalacji oprogramowania
			var generated_task = generate_installation_task(task["employee_id"])
			# Dodanie wygenerowanego zadania do file_tasks
			file_tasks.append(generated_task)

# Funkcja generująca zadanie dla instalacji oprogramowania
func generate_installation_task(employee_id: int) -> Dictionary:
	# Inkrementacja ID
	var task_id = current_id
	current_id += 1  # Zwiększamy ID o 1

	var installation_task = {
		"employee_id": employee_id,
		"topic": "Instalacja oprogramowania",
		"type": "Instalacja oprogramowania",
		"details": "Zainstalowanie nowego oprogramowania na serwerze",
		"status": "W toku",
		"id": task_id,
	}
	return installation_task

# Funkcja ustawiająca ID
func set_current_id(record_id: int) -> void:
	current_record_id = record_id
	print("Ustawiono current_record_id na:", current_record_id)

# Funkcja do pobierania aktualnego ID
func get_current_id() -> int:
	return current_record_id

# Funkcja wczytująca plik JSON
func load_json_file(file_path: String) -> Dictionary:
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		data_file.close()
		if parsed_result is Dictionary:
			return parsed_result
	return {}

# Funkcja zwracająca listę pracowników
func get_records() -> Array:
	return records

# Funkcja zwracająca listę zadań
func get_tasks() -> Array:
	return task_list

# Funkcja zwracająca listę zadań związanych z instalacją oprogramowania
func get_file_tasks() -> Array:
	return file_tasks
