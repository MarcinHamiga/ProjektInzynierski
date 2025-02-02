extends Control

signal close_record_window

var record_id: int = -1
var name_label: Label
var topic_label: Label
var type_label: Label
var email_label: Label
var attachment_button: Button  

var access_type_label: Label
var access_location_label: Label
var access_rank_label: Label

var attachment_scene: Node

var vbox: VBoxContainer 

func _ready() -> void:
	record_id = main_sip.get_current_id()

	var record = get_record_by_id(record_id, main_sip.get_records())
	var task = get_task_for_employee(record_id, main_sip.get_tasks())
	self.vbox = $Access
	name_label = $Name
	type_label = $Type
	topic_label = $Topic
	email_label = $Email
	attachment_button = $Attachment
	
	access_type_label = $Access/AccessType
	access_location_label = $Access/AccessLocation
	access_rank_label = $Access/AccessRank

	email_label.text = "Adres E-mail: "+record["email"]
	name_label.text = "Imię i nazwisko: \n"+record["name"]
	topic_label.text = "Temat: "+task["topic"]
	type_label.text = "Typ zadania: "+task["type"]
	

	if task["type"] == "Dostęp do serwera":
		print("Wywołuję funkcję dla zadania typu 'Dostęp do serwera'")
		var server_task = get_server_task(record_id)
		if server_task != {}:
			access_type_label.text = "Typ dostępu: "+server_task["access_type"]
			access_location_label.text = "Adres dostępu: " +server_task["access_location"]
			access_rank_label.text = "INFORMACJE DOSTĘPOWE\nStanowisko pracownika: "+server_task["access_rank"]
			attachment_button.visible = false
	else:
		attachment_button.show()
		handle_file_task(record, task)

func get_record_by_id(record_id: int, record_list: Array) -> Dictionary:
	for record in record_list:
		if record["id"] == record_id:
			return record
	return {} 


func get_task_for_employee(employee_id: int, task_list: Array) -> Dictionary:
	for task in task_list:
		if task["employee_id"] == employee_id:
			return task
	return {} 


func handle_server_task(record: Dictionary, task: Dictionary):
	print("Obsługuje zadanie serwera dla:", record["name"])
	var server_task = preload("res://scripts/serwery_i_pliki/server_task_generator.gd").new()
	server_task.generate_random_server_task()  

	return server_task 


func get_server_task(employee_id: int) -> Dictionary:
	var server_tasks = main_sip.get_server_tasks()
	for server_task in server_tasks:
		if server_task["id"] == employee_id:
			return server_task
	return {} 


func handle_file_task(record: Dictionary, task: Dictionary):
	var file_task_generator = preload("res://scripts/serwery_i_pliki/file_task_generator.gd").new()
	
	var random_data = file_task_generator.generate_random_data()
	if random_data.size() > 0:
		var files = random_data[0] 
	else:
		print("Brak danych do wyświetlenia.")


func _on_back_pressed() -> void:
	Globals.play_sound.emit("click")
	close_record_window.emit(self)


func _on_attachment_pressed() -> void:
	Globals.play_sound.emit("click")
	var install_permission_scene = load("res://scenes/serwery_i_pliki/install_permission.tscn").instantiate()
	install_permission_scene.back.connect(self.remove_attachment_scene)
	self.add_child(install_permission_scene)
	self.attachment_scene = install_permission_scene


func remove_attachment_scene() -> void:
	if self.attachment_scene:
		self.remove_child(self.attachment_scene)
