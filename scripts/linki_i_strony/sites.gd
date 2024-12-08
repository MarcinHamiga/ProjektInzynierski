extends Control

var json_file_path = "res://Dane/sites_data.json"
var sites_data: Array[Dictionary] = []  # Zmienna przechowująca tylko wylosowane dane

func _ready() -> void:
	# Wywołanie generowania rekordu po załadowaniu
	generate_new_record()

func generate_new_record() -> void:
	print("Teraz generowanie...")
	load_and_generate_records()
	print("Po generowaniu")
	print(get_sites_data())
	print("Teraz generowanie...")
	load_and_generate_records()
	print("Po generowaniu")
	print(get_sites_data())
func load_and_generate_records() -> void:
	randomize()

	# Wczytanie danych JSON
	var loaded_data = Globals.load_json(json_file_path)


	# Zapisanie danych do zmiennej sites_data
	# W tym momencie sites_data zawiera tylko wylosowane rekordy
	sites_data.clear()  # Upewnijmy się, że tablica jest czysta przed dodaniem nowych danych
	var is_safe = randi_range(1, 100)  # Losowanie, czy strona będzie bezpieczna czy nie
	print("is_safe: %d" % is_safe)
	get_random_site(is_safe, loaded_data)

# Funkcja do losowania strony na podstawie jej bezpieczeństwa (safe/notsafe)
func get_random_site(is_safe: int, loaded_data: Dictionary) -> void:
	var sites = {}  # Deklaracja słownika dla stron

	# Wybór strony na podstawie wartości is_safe
	if is_safe <= 50:
		sites = loaded_data.get("safe", {})  # Bezpieczne strony
	else:
		sites = loaded_data.get("notsafe", {})  # Niebezpieczne strony

	
	# Losowanie indeksu strony
	var random_index = randi() % sites["name"].size()

	# Pobranie danych strony
	var site = {
		"name": sites["name"][random_index],
		"link": sites["link"][random_index],
		"category": sites["category"][random_index],
		"reputation_score": sites["site_data"][random_index]["reputation_score"],
		"risk_description": sites["site_data"][random_index]["risk_description"],
		"server_location": sites["site_data"][random_index]["server_location"],
		"certification_valid": sites["certification"][random_index]["valid"],
		"certification_issuer": sites["certification"][random_index]["issuer"],
		"https_supported": sites["certification"][random_index]["https"]
	}

	# Dodajemy wylosowaną stronę do tablicy sites_data
	sites_data.append(site)

	# Wyświetlenie informacji o stronie
	print_site_info(site)

# Funkcja wyświetlająca informacje o stronie
func print_site_info(site: Dictionary) -> void:
	print("Nazwa strony: ", site["name"])
	print("Link: ", site["link"])
	print("Kategoria: ", site["category"])
	print("Reputacja: ", site["reputation_score"])
	print("Opis ryzyka: ", site["risk_description"])
	print("Lokalizacja serwera: ", site["server_location"])
	print("Certyfikat ważny: ", site["certification_valid"])
	print("Wydawca certyfikatu: ", site["certification_issuer"])
	print("Obsługiwany HTTPS: ", site["https_supported"])

# Funkcja zwracająca wylosowane dane stron
func get_sites_data() -> Array[Dictionary]:
	return sites_data
