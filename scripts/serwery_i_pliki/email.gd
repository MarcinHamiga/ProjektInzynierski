extends Control

var record_id: int = -1  # ID rekordu
var name_label: Label
var topic_label: Label
var type_label: Label
var email_label: Label
var attachment_button: Button  # Przycisk Attachment

var access_type_label: Label
var access_location_label: Label
var access_rank_label: Label

func _ready() -> void:
	# Odbieramy przekazane ID z metadanych
	record_id = get_meta("record_id", -1)
	print("Przekazane record_id:", record_id)

	# Pobieramy rekord pracownika
	var record = get_record_by_id(record_id, main_sip.get_records())
	# Pobieramy zadanie przypisane do pracownika
	var task = get_task_for_employee(record_id, main_sip.get_tasks())

	# Sprawdzamy, czy rekord i zadanie istnieją
	if record == {}:
		print("Nie znaleziono rekordu dla ID:", record_id)
		return
	if task == {}:
		print("Nie znaleziono zadania dla pracownika ID:", record_id)
		return

	# Sprawdzamy dane przed wyświetleniem
	print("Dane pracownika:")
	print(record)  # Drukujemy rekord pracownika
	print("Dane zadania przypisanego do pracownika:")
	print(task)  # Drukujemy zadanie przypisane do pracownika

	# Odwołanie do etykiet w scenie
	name_label = $Message/Name
	topic_label = $Message/Topic
	type_label = $Message/Type
	email_label = $Message/Email
	attachment_button = $Attachment
	
	# Etykiety dla AccessType, AccessLocation, AccessRank
	access_type_label = $Message/AccessType
	access_location_label = $Message/AccessLocation
	access_rank_label = $Message/AccessRank

	# Aktualizacja tekstu w etykietach
	name_label.text = record["name"]
	email_label.text = record["email"]
	topic_label.text = task["topic"]
	type_label.text = task["type"]

	# Sprawdzamy, czy zadanie to "Dostęp do serwera"
	if task["type"] == "Dostęp do serwera":
		print("Wywołuję funkcję dla zadania typu 'Dostęp do serwera'")
		handle_server_task(record, task)
		# Ustawiamy odpowiednie wartości w etykietach dla dostępu do serwera
		var server_task = handle_server_task(record, task)
		access_type_label.text = server_task["access_type"]
		access_location_label.text = server_task["access_location"]
		access_rank_label.text = server_task["access_rank"]
		# Ukrywamy przycisk Attachment, bo nie jest potrzebny przy zadaniach serwerowych
		attachment_button.hide()
	# Dla innych zadań (np. pliki), przycisk Attachment będzie widoczny
	else:
		attachment_button.show()
		# Obsługuje zadanie związane z plikami
		handle_file_task(record, task)

# Funkcja do pobrania rekordu pracownika na podstawie ID
func get_record_by_id(record_id: int, record_list: Array) -> Dictionary:
	for record in record_list:
		if record["id"] == record_id:
			return record
	return {}  # Ten przypadek nie powinien wystąpić

# Funkcja do pobrania zadania przypisanego do pracownika
func get_task_for_employee(employee_id: int, task_list: Array) -> Dictionary:
	for task in task_list:
		if task["employee_id"] == employee_id:
			return task
	return {}  # Ten przypadek nie powinien wystąpić

# Funkcja obsługująca zadania związane z serwerami
func handle_server_task(record: Dictionary, task: Dictionary) -> Dictionary:
	print("Obsługuje zadanie serwera dla:", record["name"])
	# Ładowanie generatora zadań serwera
	var server_task_generator = preload("res://scripts/serwery_i_pliki/server_task_generator.gd").new()
	server_task_generator._ready()  # Inicjalizacja generatora (jeśli wymaga)

	# Wywołanie funkcji specyficznej dla zadania
	var server_task = server_task_generator.add_server_task()
	return server_task  # Zwracamy wygenerowane zadanie

# Funkcja obsługująca zadania związane z plikami
func handle_file_task(record: Dictionary, task: Dictionary) -> void:
	print("Obsługuje zadanie plików dla:", record["name"])
	# Ładowanie generatora zadań plików
	var file_task_generator = preload("res://scripts/serwery_i_pliki/file_task_generator.gd").new()
	file_task_generator._ready()  # Inicjalizacja generatora (jeśli wymaga)

	# Wywołanie funkcji specyficznej dla zadania
	file_task_generator.add_file_task()  
