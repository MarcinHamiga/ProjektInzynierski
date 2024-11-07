extends Control

var vbox: VBoxContainer
var num_records := 3 # Liczba losowanych rekordów
var names = []  # Lista imion
var surnames = []  # Lista nazwisk
var topics = []  # Lista tematów zgłoszeń
var types = []  # Lista typów zgłoszeń
var record_list = []  # Lista przechowująca wszystkie wygenerowane rekordy

func _ready() -> void:
	vbox = $MessList/VBoxContainer
	var data_file_path = "res://Dane/data_2.json"  # Ścieżka do pliku JSON
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
	display_all_records()  # Wyświetla wszystkie rekordy

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

func display_all_records() -> void:
	
	for record in record_list:
		var hbox = HBoxContainer.new()  # Nowy HBoxContainer dla każdego rekordu
		hbox.set_custom_minimum_size(Vector2(0, 55))  # Ustawienie wysokości wiersza

		# Dodanie ikony
		var texture_rect = TextureRect.new()
		texture_rect.texture = load("res://icon.svg")  # Ścieżka do ikony
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture_rect.custom_minimum_size = Vector2(50, 50)
		hbox.add_child(texture_rect)

		# Dodanie imienia i nazwiska
		var name_label = Label.new()
		name_label.text = record["name"]
		name_label.custom_minimum_size = Vector2(200, 0)
		hbox.add_child(name_label)

		# Dodanie tematu zgłoszenia
		var topic_label = Label.new()
		topic_label.text = record["topic"]
		topic_label.custom_minimum_size = Vector2(300, 0)
		topic_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		topic_label.clip_text = true
		hbox.add_child(topic_label)

		# Dodanie typu zgłoszenia
		var type_label = Label.new()
		type_label.text = record["type"]
		type_label.custom_minimum_size = Vector2(250, 0)
		hbox.add_child(type_label)

		# Dodanie wiersza do VBoxContainer
		vbox.add_child(hbox)
