extends Control

var num_items := 10  # Liczba wierszy na liście
var entries = []  # Lista na dane z pliku JSON

func _ready() -> void:
	load_data()  # Wczytaj dane z pliku JSON
	add_item()  # Dodaj elementy do listy

func load_data() -> void:
	var file_path = "res://Dane/data.json"  # Ścieżka do pliku JSON
	var json_as_text = FileAccess.get_file_as_string(file_path)  # Odczytanie pliku jako tekst
	var json_as_dict = JSON.parse_string(json_as_text)  # Parsowanie danych JSON

	if json_as_dict:  # Jeśli poprawnie sparsowane
		entries = json_as_dict["entries"]  # Przypisanie wpisów do listy
	else:
		print("Błąd podczas parsowania JSON")  # Wydrukowanie błędu

func add_item():
	var vbox = $MessList/VBoxContainer  # Uzyskanie dostępu do VBoxContainer

	# Wygenerowanie elementów listy
	for i in range(num_items):
		var random_entry = entries[randi() % entries.size()]  # Losowy wybór wpisu z listy
		var hbox = HBoxContainer.new()  # Nowy HBoxContainer dla każdego wiersza
		hbox.set_custom_minimum_size(Vector2(0, 50))  # Ustawienie wysokości wiersza

		# Dodanie kontrolki "spacer" dla marginesu po lewej stronie
		var left_margin = Control.new()
		left_margin.set_custom_minimum_size(Vector2(10, 0))
		hbox.add_child(left_margin)

		# Dodanie ikony
		var texture_rect = TextureRect.new()
		texture_rect.texture = load("res://icon.svg")
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture_rect.custom_minimum_size = Vector2(50, 50)  # Ustawienie mniejszego rozmiaru ikony
		hbox.add_child(texture_rect)

		# Dodanie imienia i nazwiska
		var name_label = Label.new()
		name_label.text = random_entry["name"]  # Użyj losowego imienia i nazwiska
		name_label.custom_minimum_size = Vector2(200, 0)  # Minimalna szerokość dla imienia i nazwiska
		hbox.add_child(name_label)

		# Dodanie tematu zgłoszenia
		var topic_label = Label.new()
		topic_label.text = random_entry["topic"]  # Użyj losowego tematu zgłoszenia
		topic_label.custom_minimum_size = Vector2(300, 0)  # Minimalna szerokość dla tematu zgłoszenia
		topic_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL  # Rozciąganie na całą dostępną szerokość
		topic_label.clip_text = true  # Włączenie przycinania tekstu
		hbox.add_child(topic_label)

		# Dodanie typu zgłoszenia
		var type_label = Label.new()
		type_label.text = random_entry["type"]  # Użyj losowego typu zgłoszenia
		type_label.custom_minimum_size = Vector2(250, 0)  # Minimalna szerokość dla typu zgłoszenia
		hbox.add_child(type_label)

		# Dodanie kontrolki "spacer" dla marginesu po prawej stronie
		var right_margin = Control.new()
		right_margin.set_custom_minimum_size(Vector2(10, 0))
		hbox.add_child(right_margin)

		# Dodanie wiersza do VBoxContainer
		vbox.add_child(hbox)

		# Dodanie separatora między wierszami
		if i < num_items - 1:
			var separator = Control.new()
			separator.set_custom_minimum_size(Vector2(0, 10))  # Ustawienie wysokości odstępu między wierszami
			vbox.add_child(separator)
