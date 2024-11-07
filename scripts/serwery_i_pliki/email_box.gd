extends Control

var vbox: VBoxContainer
var num_records := 4  # Liczba losowanych rekordów
var record_list = []  # Lista przechowująca wszystkie wygenerowane rekordy

func _ready() -> void:
	vbox = $MessList/VBoxContainer
	
	# Ładowanie danych i generowanie rekordów za pomocą MainSIP
	MainSIP.load_and_generate_records()  # Wczytanie danych i generowanie rekordów
	record_list = MainSIP.get_records()  # Pobieramy wygenerowane rekordy
	
	display_all_records()  # Wyświetlamy wszystkie rekordy

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

		# Dodanie przycisku do przekazania ID
		var button = Button.new()
		button.text = "Zobacz szczegóły"
		button.pressed.connect(self._on_button_pressed.bind(record["id"]))  # Przekazujemy ID rekordu
		hbox.add_child(button)

		# Dodanie wiersza do VBoxContainer
		vbox.add_child(hbox)

# Funkcja, która obsługuje kliknięcie przycisku
func _on_button_pressed(record_id: int) -> void:
	if record_id <= 0:  # Sprawdzamy, czy ID jest prawidłowe
		print("Nieprawidłowe ID rekordu:", record_id)
		return  # Przerywamy, jeśli ID jest niewłaściwe

	# Ładowanie sceny email.tscn
	var email_scene = load("res://scenes/serwery_i_pliki/email.tscn").instantiate()
	
	# Przekazanie ID do nowej sceny
	email_scene.set_meta("record_id", record_id)

	# Dodanie sceny do drzewa scen
	get_tree().current_scene.add_child(email_scene)
