extends Node

# Ścieżka do pliku JSON
var file_path = "res://Dane/files.json"

# Funkcja do generowania danych
func generate_random_data() -> Array:
	# Otwieramy plik
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if file:
		var json_data = file.get_as_text()  # Odczytanie pliku jako tekst
		var json_parser = JSON.new()
		var result = json_parser.parse(json_data)  # Parsowanie tekstu do formatu JSON
		
		if result == OK:
			var json_object = json_parser.get_data()  # Pobranie sparsowanych danych
			
			# Losowanie, czy będzie safe czy notsafe
			var is_safe = randi() % 2 == 0  # Losowanie 0 lub 1 (safe = true, notsafe = false)
			
			# Losowanie jednego rekordu
			var name_random = get_random_name(json_object["name"])
			var creator_random = ""
			if is_safe:
				creator_random = get_random_creator(json_object["creator"]["safe"])
				main_sip.set_answer(true)
			else:
				creator_random = get_random_creator(json_object["creator"]["notsafe"])
				main_sip.set_answer(false)

			var ext_random = ""
			if is_safe:
				ext_random = get_random_extension(json_object["extension"]["safe"])
			else:
				ext_random = get_random_extension(json_object["extension"]["notsafe"])

			# Tworzymy słownik z wynikiem
			var record = {
				"name": name_random,
				"creator": creator_random,
				"extension": ext_random
			}

			# Zwracamy wynik w postaci listy z jednym słownikiem
			return [record]
		else:
			print("Błąd parsowania JSON:", json_parser.get_error_message())
			return []  # W przypadku błędu zwracamy pustą listę
	else:
		print("Błąd otwarcia pliku:", file_path)
		return []  # W przypadku błędu otwarcia pliku zwracamy pustą listę

# Funkcja pomocnicza do losowania nazwy pliku
func get_random_name(names: Array) -> String:
	if names.size() > 0:
		return names[randi() % names.size()]  # Losowanie elementu
	else:
		return "Brak danych"  # Zwracamy domyślną wartość, jeśli nie ma danych

# Funkcja pomocnicza do losowania twórcy (safe/notsafe)
func get_random_creator(creator_list: Array) -> String:
	if creator_list != null and creator_list.size() > 0:
		return creator_list[randi() % creator_list.size()]  # Losowanie twórcy
	else:
		return "Brak twórców"  # Zwracamy domyślną wartość, jeśli brak twórców

# Funkcja pomocnicza do losowania rozszerzenia (safe/notsafe)
func get_random_extension(extension_list: Array) -> String:
	if extension_list.size() > 0:
		# Losowanie rozszerzenia z listy
		var ext = extension_list[randi() % extension_list.size()]
		# Zwrócenie typu aplikacji oraz rozszerzenia
		return ext["app_type"] + ": " + ext["extension"]
	else:
		return "Brak rozszerzeń"  # Zwracamy domyślną wartość, jeśli brak rozszerzeń
