extends Node
var file_path = "res://Dane/files.json"


func _ready() -> void:
	randomize()

func generate_random_data() -> Array:
	# Otwieramy plik
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if file:
		var json_data = file.get_as_text()  
		var json_parser = JSON.new()
		var result = json_parser.parse(json_data)
		
		if result == OK:
			var json_object = json_parser.get_data()  
			
			var is_safe = randi_range(1, 100)
			
			#print("is_safe: %d" % [is_safe])
			
			var name_random = get_random_name(json_object["name"])
			var creator_random = ""
			if is_safe >= 50:
				creator_random = get_random_creator(json_object["creator"]["safe"])
				main_sip.set_answer(true)
			else:
				creator_random = get_random_creator(json_object["creator"]["notsafe"])
				main_sip.set_answer(false)

			var ext_random = ""
			if is_safe:
				ext_random = get_random_extension(json_object["extension"]["safe"])
			else:
				ext_random = get_random_extension(json_object["extension"]["notsafe"])

			var record = {
				"name": name_random,
				"creator": creator_random,
				"extension": ext_random
			}

			return [record]
		else:
			print("Błąd parsowania JSON:", json_parser.get_error_message())
			return []  
	else:
		print("Błąd otwarcia pliku:", file_path)
		return []  

func get_random_name(names: Array) -> String:
	if names.size() > 0:
		return names[randi() % names.size()]  
	else:
		return "Brak danych" 

func get_random_creator(creator_list: Array) -> String:
	if creator_list != null and creator_list.size() > 0:
		return creator_list[randi() % creator_list.size()] 
	else:
		return "Brak twórców"  

# Funkcja pomocnicza do losowania rozszerzenia (safe/notsafe)
func get_random_extension(extension_list: Array) -> String:
	if extension_list.size() > 0:
		var ext = extension_list[randi() % extension_list.size()]
		return ext["app_type"] + ": " + ext["extension"]
	else:
		return "Brak rozszerzeń"  
