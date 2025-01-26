extends Control

signal back

var _task = {}  # Słownik przechowujący zadanie
var record = {}  # Słownik przechowujący dane pracownika

var extension_label: Label
var name_type_label: Label
var creator_label: Label

func _ready() -> void:
	var record_id = main_sip.get_current_id()

	if record_id != -1:
		
		_task = get_task_by_employee_id(record_id)
		
		if _task == {}:
			print("Nie znaleziono zadania dla pracownika ID:", record_id)
			return
		
		
		extension_label = $Extension
		name_type_label = $Name
		creator_label = $Creator

		name_type_label.text = "Nazwa pliku: \t"+_task["file_name"]
		creator_label.text = "Twórca oprogramowania: "+_task["file_creator"]
		extension_label.text = "Rozszerzenie pliku: "+_task["file_extension"]
	else:
		print("Nieprawidłowe ID rekordu")

func get_task_by_employee_id(employee_id: int) -> Dictionary:
	for task in main_sip.get_file_tasks():
		if task["id"] == employee_id:
			return task
	return {}  


func _on_close_pressed() -> void:
	back.emit()
