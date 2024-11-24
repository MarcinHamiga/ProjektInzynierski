extends Control

var task = {}  # Słownik przechowujący zadanie
var record = {}  # Słownik przechowujący dane pracownika

var extension_label: Label
var name_type_label: Label
var creator_label: Label

func _ready() -> void:
	# Pobieranie record_id z main_sip
	var record_id = main_sip.get_current_id()

	if record_id != -1:
		# Pobierz dane pracownika
		#record = main_sip.get_record_by_id(record_id, main_sip.get_records())
		
		# Sprawdzamy, czy zadanie istnieje w tablicy file_tasks
		task = get_task_by_employee_id(record_id)
		
		if task == {}:
			print("Nie znaleziono zadania dla pracownika ID:", record_id)
			return
		
		# Znajdź odpowiednie etykiety
		extension_label = $Extension
		name_type_label = $Name
		creator_label = $Creator

		# Zaktualizuj etykiety danymi
		name_type_label.text = task["name"]
		creator_label.text = task["creator"]
		extension_label.text = task["extension"]
	else:
		print("Nieprawidłowe ID rekordu")

# Funkcja do pobrania zadania na podstawie ID pracownika
func get_task_by_employee_id(employee_id: int) -> Dictionary:
	for task in main_sip.get_file_tasks():
		if task["employee_id"] == employee_id:
			return task
	return {}  # Jeśli nie znaleziono zadania
