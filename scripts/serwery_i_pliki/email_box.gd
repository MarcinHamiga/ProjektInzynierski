extends Control
signal new_record
var vbox: VBoxContainer
var record_list = []  # Lista pracowników
var task_list = []    # Lista zadań
var file_tasks = []
func _ready() -> void:
	vbox = $MessList/VBoxContainer
	# Ładowanie danych i generowanie rekordów za pomocą MainSIP
	main_sip.load_and_generate_records()  # Wczytanie danych i generowanie rekordów
	record_list = main_sip.get_records()  # Pobieramy listę pracowników
	task_list = main_sip.get_tasks()      # Pobieramy listę zadań
	file_tasks = main_sip.get_file_tasks()
	new_record.emit()
	display_all_records()  # Wyświetlamy wszystkie rekordy

func display_all_records() -> void:
	for record in record_list:
		var hbox = HBoxContainer.new()
		hbox.set_custom_minimum_size(Vector2(0, 55))

		# Dodanie ikony
		var texture_rect = TextureRect.new()
		texture_rect.texture = load("res://icon.svg")
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture_rect.custom_minimum_size = Vector2(50, 50)
		hbox.add_child(texture_rect)

		# Dodanie imienia i nazwiska
		var name_label = Label.new()
		name_label.text = record["name"]
		name_label.custom_minimum_size = Vector2(200, 0)
		hbox.add_child(name_label)

		# Pobranie zadania przypisanego do pracownika
		var assigned_task = get_task_for_employee(record["id"])

		# Dodanie tematu zgłoszenia
		var topic_label = Label.new()
		topic_label.text = assigned_task["topic"]
		topic_label.custom_minimum_size = Vector2(300, 0)
		topic_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		topic_label.clip_text = true
		hbox.add_child(topic_label)

		# Dodanie typu zgłoszenia
		var type_label = Label.new()
		type_label.text = assigned_task["type"]
		type_label.custom_minimum_size = Vector2(250, 0)
		hbox.add_child(type_label)

		# Dodanie przycisku do przekazania ID
		var button = Button.new()
		button.text = "Zobacz szczegóły"
		button.pressed.connect(self._on_button_pressed.bind(record["id"]))
		hbox.add_child(button)

		# Dodanie wiersza do VBoxContainer
		vbox.add_child(hbox)

func get_task_for_employee(employee_id: int) -> Dictionary:
	for task in task_list:
		if task["employee_id"] == employee_id:
			return task
	return {}  # Zwracamy pusty słownik, jeśli nie znaleziono zadania

# email_box.gd
func _on_button_pressed(record_id: int) -> void:
	# Ustawiamy aktualne ID w main_sip
	main_sip.set_current_id(record_id)
	
	# Możemy teraz wczytać dane z głównej sceny, np. wyświetlić dane w etykietach
	var email_scene = load("res://scenes/serwery_i_pliki/email.tscn").instantiate()
	get_tree().current_scene.add_child(email_scene)
