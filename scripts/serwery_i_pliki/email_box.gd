extends Control
signal new_record
var vbox: VBoxContainer
var record_list: Array  # Lista pracowników
var task_list: Array    # Lista zadań
var file_tasks: Array
var current_email_scene: Node


func _ready() -> void:
	self.vbox = $MessList/MessVBox
	#self.generate_new_record()
	main_sip.regenerate.connect(generate_new_record)


func generate_new_record() -> void:
	for child in self.vbox.get_children():
		self.vbox.remove_child(child)
	main_sip.load_and_generate_records()
	main_sip.process_tasks()
	record_list = main_sip.get_records()
	task_list = main_sip.get_tasks()
	file_tasks = main_sip.get_file_tasks()
	
	#print(main_sip.get_answer)
	
	display_all_records()

func display_all_records() -> void:
	for record in record_list:
		var hbox: HBoxContainer = HBoxContainer.new()
		hbox.set_custom_minimum_size(Vector2(0, 55))

		# Dodanie ikony
		var texture_rect: TextureRect = TextureRect.new()
		texture_rect.texture = load("res://icon.svg")
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture_rect.custom_minimum_size = Vector2(50, 50)
		hbox.add_child(texture_rect)

		# Dodanie imienia i nazwiska
		var name_label: Label = Label.new()
		name_label.text = record["name"]
		name_label.custom_minimum_size = Vector2(200, 0)
		hbox.add_child(name_label)

		# Pobranie zadania przypisanego do pracownika
		var assigned_task = get_task_for_employee(record["id"])

		# Dodanie tematu zgłoszenia
		var topic_label: Label = Label.new()
		topic_label.text = assigned_task["topic"]
		topic_label.custom_minimum_size = Vector2(300, 0)
		topic_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		topic_label.clip_text = true
		hbox.add_child(topic_label)

		# Dodanie typu zgłoszenia
		var type_label: Label = Label.new()
		type_label.text = assigned_task["type"]
		type_label.custom_minimum_size = Vector2(250, 0)
		hbox.add_child(type_label)

		# Dodanie przycisku do przekazania ID
		var button: Button = Button.new()
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
	self.current_email_scene = email_scene
	email_scene.close_record_window.connect(self.close_record_window)
	new_record.emit(main_sip.get_answer())
	self.add_child(email_scene)
	

func close_record_window(node: Node) -> void:
	self.remove_child(node)

func _on_visibility_changed() -> void:
	if self.current_email_scene:
		self.remove_child(self.current_email_scene)
		self.current_email_scene = null
