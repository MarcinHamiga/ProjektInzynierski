extends Node
signal regenerate

var json_file_path = "res://Dane/sites_data.json"


func _ready() -> void:
	pass

func load_and_generate_records() -> void:
	randomize()
	
	var sites_data = load_json_data()
	var is_safe = randi_range(1, 100)
	print("is_safe: %d" % is_safe)
	var random_site = get_random_site(is_safe, sites_data)
	
	if random_site.size() > 0:
		print_site_info(random_site)
	else:
		print("Brak dostępnych danych")


func load_json_data() -> Dictionary:
	# Otwieramy plik
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	if file:
		var json_data = file.get_as_text()  # Odczytanie pliku jako tekst
		var json_parser = JSON.new()
		var result = json_parser.parse(json_data)  # Parsowanie tekstu do formatu JSON
		if result == OK:
			var json_object = json_parser.get_data()  # Pobranie sparsowanych danych
			file.close()
			return json_object
		else:
			print("Błąd parsowania JSON:", json_parser.get_error_message())
			file.close()
			return {}
	else:
		print("Błąd otwarcia pliku:", json_file_path)
		return {}

func get_random_site(is_safe: int, sites_data: Dictionary) -> Dictionary:
	var selected_sites = {}
	if is_safe <= 50:
		selected_sites = sites_data.get("safe", {})
	else:
		selected_sites = sites_data.get("notsafe", {})

	var random_index = randi() % selected_sites["name"].size()
	return get_site_data(selected_sites, random_index)


func get_site_data(sites, index) -> Dictionary:
	var site = {
		"name": sites["name"][index],
		"link": sites["link"][index],
		"category": sites["category"][index],
		"reputation_score": sites["site_data"][index]["reputation_score"],
		"risk_description": sites["site_data"][index]["risk_description"],
		"server_location": sites["site_data"][index]["server_location"],
		"certification_valid": sites["certification"][index]["valid"],
		"certification_issuer": sites["certification"][index]["issuer"],
		"https_supported": sites["certification"][index]["https"]
	}
	return site

# Funkcja wyświetlająca informacje o stronie
func print_site_info(site):
	print("Nazwa strony: ", site["name"])
	print("Link: ", site["link"])
	print("Kategoria: ", site["category"])
	print("Reputacja: ", site["reputation_score"])
	print("Opis ryzyka: ", site["risk_description"])
	print("Lokalizacja serwera: ", site["server_location"])
	print("Certyfikat ważny: ", site["certification_valid"])
	print("Wydawca certyfikatu: ", site["certification_issuer"])
	print("Obsługiwany HTTPS: ", site["https_supported"])

# Funkcja główna
