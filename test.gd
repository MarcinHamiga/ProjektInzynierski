extends Node  # Używamy Node zamiast Control, aby uprościć strukturę

var num_records := 40  # Liczba losowanych rekordów
var full_names = []  # Lista pełnych imion i nazwisk
var topics = []  # Lista tematów zgłoszeń
var types = []  # Lista typów zgłoszeń

func _ready() -> void:
	var data_file_path = "res://Dane/data_2.json"  # Zaktualizowana ścieżka do pliku JSON
	var itemData = load_json_file(data_file_path)  # Wczytaj dane z pliku JSON

	# Uzupełnienie list pełnych imion i tematów oraz typów z itemData
	if itemData.has("names") and itemData.has("surnames"):
		for i in range(itemData["names"].size()):
			full_names.append(itemData["names"][i] + " " + itemData["surnames"][i])  # Łączenie imienia i nazwiska
	if itemData.has("topics"):
		topics = itemData["topics"]
	if itemData.has("types"):
		types = itemData["types"]

	display_random_records()  # Wyświetl losowe rekordy w terminalu

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

func display_random_records():
	# Sprawdź, czy tablice mają dane
	if full_names.size() == 0:
		print("Brak pełnych imion i nazwisk do losowania.")
		return
	if topics.size() == 0:
		print("Brak tematów do losowania.")
		return
	if types.size() == 0:
		print("Brak typów do losowania.")
		return

	# Wygenerowanie losowych rekordów
	for i in range(num_records):
		var name_index = randi() % full_names.size()  # Wybór losowego indeksu dla pełnego imienia
		var topic_index = randi() % topics.size()  # Typ zgłoszenia może nie być unikalny
		var type_index = randi() % types.size()  # Typ zgłoszenia może nie być unikalny

		# Wypisanie rekordu w terminalu
		print("Rekord " + str(i + 1) + ": " + full_names[name_index] +
			  ", Temat: " + topics[topic_index] + 
			  ", Typ: " + types[type_index])
