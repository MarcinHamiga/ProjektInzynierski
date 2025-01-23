extends Control
signal answer_sites
var answer: bool = false


var json_file_path = "res://Dane/sites_data.json"
var sites_data: Array[Dictionary] = []
var vbox: VBoxContainer 

func _ready() -> void:
	self.vbox = $SitesList/SitesVBox

func generate_new_record() -> void:

	load_and_generate_records()
	display_all_sites()
	print(answer)

func load_and_generate_records() -> void:
	randomize()

	var loaded_data = Globals.load_json(json_file_path)
	sites_data.clear()
	var children = self.vbox.get_children()
	for child in children:
		child.queue_free()
	var is_safe = randi_range(1, 100)
	get_random_site(is_safe, loaded_data)

func get_random_site(is_safe: int, loaded_data: Dictionary) -> void:
	var sites = {}
	if is_safe <= 65:
		sites = loaded_data.get("safe", {})
		set_answer(true)
	else:
		sites = loaded_data.get("notsafe", {})
		set_answer(false)

	var random_index = randi() % sites["name"].size()
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

	sites_data.append(site)

func display_all_sites() -> void:

	for site in sites_data:
		var site_vbox: VBoxContainer = VBoxContainer.new()
		site_vbox.add_theme_constant_override("separation", 10)
		var separator = HSeparator.new()
		separator = HSeparator.new()
		site_vbox.add_child(separator)
		
		var name_label: Label = Label.new()
		name_label.text = "Nazwa strony: " + site["name"]
		site_vbox.add_child(name_label)

		var link_label: Label = Label.new()
		link_label.text = "Link: " + site["link"]
		site_vbox.add_child(link_label)

		var category_label: Label = Label.new()
		category_label.text = "Kategoria: " + site["category"]
		site_vbox.add_child(category_label)

		separator = HSeparator.new()
		site_vbox.add_child(separator)

		var reputation_label: Label = Label.new()
		reputation_label.text = "Reputacja: " + str(site["reputation_score"])
		site_vbox.add_child(reputation_label)

		var location_label: Label = Label.new()
		location_label.text = "Lokalizacja serwera: " + site["server_location"]
		site_vbox.add_child(location_label)

		var risk_label: Label = Label.new()
		risk_label.text = "Opis ryzyka: " + site["risk_description"]
		site_vbox.add_child(risk_label)

		separator = HSeparator.new()
		site_vbox.add_child(separator)

		var cert_valid_label: Label = Label.new()
		cert_valid_label.text = "Certyfikat ważny: " + ("Tak" if site["certification_valid"] else "Nie")
		site_vbox.add_child(cert_valid_label)

		var cert_issuer_label: Label = Label.new()
		cert_issuer_label.text = "Wydawca certyfikatu: " + site["certification_issuer"]
		site_vbox.add_child(cert_issuer_label)

		var https_label: Label = Label.new()
		https_label.text = "Obsługiwany HTTPS: " + ("Tak" if site["https_supported"] else "Nie")
		site_vbox.add_child(https_label)

		vbox.add_child(site_vbox)
		separator = HSeparator.new()
		site_vbox.add_child(separator)

func set_answer(answer_temp) -> void:
	answer = answer_temp
	answer_sites.emit(answer)


func _on_task_manager_generate_new_sites() -> void:
	self.generate_new_record()
