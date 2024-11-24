extends Node

# Ścieżka do pliku JSON
var file_path = "res://Dane/servers.json"

func generate_random_server_task() -> Array:
	# Otwieramy plik JSON
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if file:
		var json_data = file.get_as_text()  
		var json_parser = JSON.new()
		var result = json_parser.parse(json_data)  
		
		if result == OK:
			var json_object = json_parser.get_data()
			
			var is_safe = randi() % 2 == 0 
			
			var task = {}
			if is_safe:
				task = get_random_task(json_object["safe"])
				main_sip.set_answer(true)
			else:
				task = get_random_task(json_object["notsafe"])
				main_sip.set_answer(false)

			# Tworzenie zadania
			var server_task = {
				"access_rank": task["access_rank"],
				"access_location": task["access_location"],
				"access_type": task["access_type"]
			}

			# Zwracamy wynik jako pojedynczy słownik w liście
			return [server_task]
		else:
			print("Błąd parsowania JSON:", json_parser.get_error_message())
			return []  # W przypadku błędu zwracamy pustą listę
	else:
		print("Błąd otwarcia pliku:", file_path)
		return []  # W przypadku błędu otwarcia pliku zwracamy pustą listę

# Funkcja pomocnicza do losowania rekordu z listy
func get_random_task(task_list: Array) -> Dictionary:
	if task_list.size() > 0:
		return task_list[randi() % task_list.size()]  # Losowanie elementu
	else:
		return {}  # Zwracamy pusty słownik, jeśli brak danych
