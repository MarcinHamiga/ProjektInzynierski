extends Control

var record_id: int = -1  # Zmienna na ID rekordu, ustawiona na domyślną wartość
var name_label: Label
var topic_label: Label
var type_label: Label

func _ready() -> void:
	# Odbieramy przekazane ID z metadanych
	record_id = get_meta("record_id", -1)
	print("Przekazane record_id:", record_id)  # Dodajemy print, aby zobaczyć, jakie ID jest przekazywane
	if record_id != -1:
		# Uzyskujemy dostęp do głównego skryptu (MainSIP) i pobieramy listę rekordów
		var main_sip = get_node("/root/MainSIP")  # Uzyskujemy dostęp do MainSIP
		var record_list = main_sip.get_records()  # Pobieramy rekordy z MainSIP

		# Szukamy rekordu na podstawie ID
		var record = get_record_by_id(record_id, record_list)

		# Jeśli rekord istnieje, wyświetlamy szczegóły
		if record != null:
			# Poprawne ścieżki do etykiet w scenie
			var name_label = $Message/Name  # Odwołanie do Label "Name"
			var topic_label = $Message/Topic  # Odwołanie do Label "Topic"
			var type_label = $Message/Type  # Odwołanie do Label "Type"

			# Dodajemy printy do sprawdzenia, czy etykiety istnieją
			print("Name Label:", name_label)
			print("Topic Label:", topic_label)
			print("Type Label:", type_label)

			# Ustawienie tekstu w labelach
			if name_label != null:
				name_label.text = record["name"]
			if topic_label != null:
				topic_label.text = record["topic"]
			if type_label != null:
				type_label.text = record["type"]

func get_record_by_id(record_id: int, record_list: Array) -> Dictionary:
	# Zwróć rekord o danym ID
	for record in record_list:
		if record["id"] == record_id:
			return record
	return {}  # Zwróć null, jeśli rekord nie został znaleziony
