extends Node

var itemData: Dictionary
var files_list := []
var next_id := 0

func load_json_file(file_path: String) -> Dictionary:
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		data_file.close()
		if parsed_result is Dictionary:
			return parsed_result
		else:
			print("Błąd podczas odczytu pliku:", parsed_result)
	else:
		print("Plik nie istnieje!")
	return {}
	
func _ready() -> void:
	itemData = load_json_file("res://Dane/files.json")  # Wczytaj dane z pliku JSON
	print(itemData)
	
func generate_unique_id() -> int:
	var id = next_id
	next_id += 1
	return id

func add_to_list(value) -> int:
	var new_id = generate_unique_id()
	var element = { "id": new_id, "value": value }
	files_list.append(element)
	return new_id
	
func remove_from_list(id: int) -> void:
	for element in files_list:
		if element.id == id:
			files_list.erase(element)
	
func addFileTask():
	var probability = 0.5
	if randf() < probability:
		return notSafe()
	else:
		return safe()

func safe():
	while true:
		var new_file = {
			"id": generate_unique_id(),
			"name": itemData["name"].pick_random(),
			"creator": itemData["creator"]["safe"].pick_random(),
			"extension": itemData["extension"]["safe"].pick_random(),
		}
		if not object_exists(new_file):
			files_list.append(new_file)
			return new_file

func notSafe():
	while true:
		var new_file = {
			"id": generate_unique_id(),
			"name": itemData["name"].pick_random(),
			"creator": itemData["creator"]["notsafe"].pick_random(),
			"extension": itemData["extension"]["notsafe"].pick_random(),
		}
		if not object_exists(new_file):
			files_list.append(new_file)
			return new_file
	

func object_exists(obj) -> bool:
	for file in files_list:
		if file["name"] == obj["name"] and file["creator"] == obj["creator"] and file["extension"] == obj["extension"]:
			return true
	return false
