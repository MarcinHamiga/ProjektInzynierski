extends Control

var record_id: int = -1  # Zmienna na ID rekordu, ustawiona na domyślną wartość
var name_label: Label
var topic_label: Label
var type_label: Label

func _ready() -> void:
	# Odbieramy przekazane ID z metadanych
	
	#Test
	var Test_file = preload("res://scripts/serwery_i_pliki/file_task_generator.gd")
	var test_file = Test_file.new()
	test_file._ready()
	print("")
	print("Generator files:")
	print(test_file.add_file_task())
	print("")
	
	var Test_server = preload("res://scripts/serwery_i_pliki/server_task_generator.gd")
	var test_server = Test_server.new()
	test_server._ready()
	print("")
	print("Generator servers:")
	print(test_server.add_server_task())
	print("")
	
	record_id = get_meta("record_id", -1)
	print("Przekazane record_id:", record_id)  # Dodajemy print, aby zobaczyć, jakie ID jest przekazywane
	if record_id != -1:
		# Uzyskujemy dostęp do głównego skryptu (MainSIP) i pobieramy listę rekordów
		var record_list = main_sip.get_records()  # Pobieramy rekordy z MainSIP
		# Szukamy rekordu na podstawie ID
		var record = get_record_by_id(record_id, record_list)

		# Jeśli rekord istnieje, wyświetlamy szczegóły
		if record != null:
			# Poprawne ścieżki do etykiet w scenie
			var name_label = $Message/Name  # Odwołanie do Label "Name"
			var topic_label = $Message/Topic  # Odwołanie do Label "Topic"
			var type_label = $Message/Type  # Odwołanie do Label "Type"
			var email_label = $Message/Email

			# Dodajemy printy do sprawdzenia, czy etykiety istnieją
			print("Name Label:", name_label)
			print("Topic Label:", topic_label)
			print("Type Label:", type_label)
			print("Email Label:", email_label)

			# Ustawienie tekstu w labelach
			if name_label != null:
				name_label.text = record["name"]
			if topic_label != null:
				topic_label.text = record["topic"]
			if type_label != null:
				type_label.text = record["type"]
			if email_label != null:
				email_label.text = record["email"]

func get_record_by_id(record_id: int, record_list: Array) -> Dictionary:
	# Zwróć rekord o danym ID
	for record in record_list:
		if record["id"] == record_id:
			return record
	return {}  # Zwróć null, jeśli rekord nie został znaleziony
