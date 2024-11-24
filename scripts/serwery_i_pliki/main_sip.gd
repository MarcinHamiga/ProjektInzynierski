extends Node

# Liczba rekordów
var num_records := 1  
var records = []      
var task_list = []    
var file_tasks = []  # Zadania plikowe
var server_tasks = []  # Zadania serwerowe
var current_id := 1   
var current_record_id: int = -1  
var required_answer = false

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
	# Przechodzimy przez wszystkie zadania w task_list
	for task in task_list:
		if task["type"] == "Instalacja oprogramowania":
			var file_task_generator = preload("res://scripts/serwery_i_pliki/file_task_generator.gd").new()
			# Generowanie losowych danych z file_task_generator
			var random_data = file_task_generator.generate_random_data()

			if random_data.size() > 0:
				var file_info = random_data[0]  # Pobieramy pierwszy (i jedyny) element z listy

				# Tworzymy nowy słownik dla file_tasks z ID z task_list
				var installation_task = {
					"id": task["employee_id"],  # Używamy ID z odpowiedniego zadania w task_list
					"file_name": file_info["name"],
					"file_creator": file_info["creator"],
					"file_extension": file_info["extension"],
				}

				# Dodajemy słownik do file_tasks
				file_tasks.append(installation_task)
			else:
				print("Nie udało się wygenerować danych pliku dla zadania instalacji.")

		elif task["type"] == "Dostęp do serwera":
			var server_task_generator = preload("res://scripts/serwery_i_pliki/server_task_generator.gd").new()
			# Generowanie losowych danych z server_task_generator
			var random_data = server_task_generator.generate_random_server_task()

			if random_data.size() > 0:
				var server_info = random_data[0]  # Pobieramy pierwszy (i jedyny) element z listy

				# Tworzymy nowy słownik dla server_tasks z ID z task_list
				var server_access_task = {
					"id": task["employee_id"],  # Używamy ID z odpowiedniego zadania w task_list
					"access_rank": server_info["access_rank"],
					"access_location": server_info["access_location"],
					"access_type": server_info["access_type"],
				}

				# Dodajemy słownik do server_tasks
				server_tasks.append(server_access_task)
			else:
				print("Nie udało się wygenerować danych serwera dla zadania dostępu.")

	# Po przetworzeniu wszystkich zadań resetujemy current_id
	current_id = -1


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

func set_answer(answer):
	required_answer = answer

func get_answer() -> bool:
	return required_answer

# Funkcja zwracająca listę pracowników
func get_records() -> Array:
	return records

# Funkcja zwracająca listę zadań
func get_tasks() -> Array:
	return task_list

# Funkcja zwracająca listę zadań związanych z instalacją oprogramowania
func get_file_tasks() -> Array:
	return file_tasks

# Funkcja zwracająca listę zadań związanych z dostępem do serwera
func get_server_tasks() -> Array:
	return server_tasks
