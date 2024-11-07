extends Node
var num_records := 4 
var records = []  # Lista przechowująca wszystkie wygenerowane rekordy

func _ready() -> void:
	load_and_generate_records()  # Załaduj dane i wygeneruj rekordy

func load_and_generate_records():
	var data_file_path = "res://Dane/data_2.json"  # Ścieżka do pliku JSON
	var itemData = load_json_file(data_file_path)  # Wczytaj dane z pliku JSON

	# Uzupełnienie list imion, nazwisk, tematów oraz typów z itemData
	var names = itemData["names"]
	var surnames = itemData["surnames"]
	var topics = itemData["topics"]
	var types = itemData["types"]

	# Generowanie rekordów
	records.clear()  # Wyczyść poprzednią listę przed generowaniem nowych
	for i in range(num_records):
		# Wylosuj imię, nazwisko, temat i typ zgłoszenia
		var name_index = randi() % names.size()
		var surname_index = randi() % surnames.size()
		var topic_index = randi() % topics.size()
		var type_index = randi() % types.size()

		# Tworzenie unikalnego ID oraz rekordu
		var record = {
			"id": i + 1,  # Unikalne ID
			"name": names[name_index] + " " + surnames[surname_index],  # Losowane imię i nazwisko
			"topic": topics[topic_index],
			"type": types[type_index]
		}

		# Dodanie rekordu do listy
		records.append(record)

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

func get_records() -> Array:
	print("Dostępne rekordy:", records)  # Dodajemy print, żeby zobaczyć zawartość listy
	return records
