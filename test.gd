extends Node  # Używamy Node zamiast Control, aby uprościć strukturę

var num_records := 40  # Liczba losowanych rekordów
var names = []  # Lista imion
var surnames = []  # Lista nazwisk
var topics = []  # Lista tematów zgłoszeń
var types = []  # Lista typów zgłoszeń
var record_list = []  # Lista przechowująca wszystkie wygenerowane rekordy

func _ready() -> void:
	var data_file_path = "res://Dane/data_2.json"  # Zaktualizowana ścieżka do pliku JSON
	var itemData = load_json_file(data_file_path)  # Wczytaj dane z pliku JSON

	# Uzupełnienie list imion, nazwisk, tematów oraz typów z itemData
	if itemData.has("names"):
		names = itemData["names"]
	if itemData.has("surnames"):
		surnames = itemData["surnames"]
	if itemData.has("topics"):
		topics = itemData["topics"]
	if itemData.has("types"):
		types = itemData["types"]

	generate_random_records()  # Generuje i dodaje rekordy do listy
	display_records_in_terminal()  # Wyświetla wygenerowane rekordy w terminalu

func load_json_file(file_path: String) -> Dictionary:
	if FileAccess.file_exists(file_path):  # Sprawdzenie, czy plik istnieje
		var data_file = FileAccess.open(file_path, FileAccess.READ)  # Otwórz plik
		var parsed_result = JSON.parse_string(data_file.get_as_text())  # Parsowanie danych JSON
		data_file.close()  # Zamknij plik po odczycie

		if parsed_result is Dictionary:
			return parsed_result  # Zwróć wynik parsowania
		else:
			print("Błąd podczas odczytu pliku:", parsed_result)  # Informacja o błędzie
	else:
		print("Plik nie istnieje!")  # Informacja o nieistniejącym pliku
	return {}  # Zwróć pusty słownik, jeśli coś poszło nie tak

func generate_random_records():
	record_list.clear()  # Wyczyść listę rekordów przed generowaniem nowych

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
		record_list.append(record)

func display_records_in_terminal():
	# Wyświetl każdy rekord w terminalu
	for record in record_list:
		print("ID:", record["id"], ", Name:", record["name"], ", Topic:", record["topic"], ", Type:", record["type"])
		
func get_record_list() -> Array:
	return record_list
