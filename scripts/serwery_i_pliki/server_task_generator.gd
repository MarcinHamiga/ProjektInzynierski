extends Node

var itemData: Dictionary
var servers_list := []
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
	itemData = load_json_file("res://Dane/servers.json")  # Wczytaj dane z pliku JSON
	
func generate_unique_id() -> int:
	var id = next_id
	next_id += 1
	return id
	
func remove_from_list(id: int) -> void:
	for element in servers_list:
		if element.id == id:
			servers_list.erase(element)
	
func add_server_task():
	while true:
		var new_server = {
			"id": generate_unique_id(),
			"access_type": itemData["access_type"].pick_random(),
			"access_location": itemData["access_location"].pick_random(),
			"access_rank": itemData["access_rank"].pick_random(),
		}
		if not object_exists(new_server):
			servers_list.append(new_server)
			return new_server

func object_exists(obj) -> bool:
	for file in servers_list:
		if file["access_type"] == obj["access_type"] and file["access_location"] == obj["access_location"] and file["access_rank"] == obj["access_rank"]:
			return true
	return false

func get_task(id):
	for server in servers_list:
		if server["id"] == id:
			return server
