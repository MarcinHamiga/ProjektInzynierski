extends Node

enum GameState { MAIN_MENU, GAME, MENU_SETTINGS, INGAME_MENU, INGAME_TASK }
enum Tasks { NONE, LOGIN_CHECK }

# Login rule keys
const PAS1: String = "PAS1"
const PAS2: String = "PAS2"
const PAS3: String = "PAS3"
const PAS4: String = "PAS4"
const PAS5: String = "PAS5"
const PAS6: String = "PAS6"
const PAS7: String = "PAS7"

func load_json(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.ModeFlags.READ)
	if file == null:
		print("Failed to open file!")
		return
	
	var json_data = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_data)
	
	if error != OK:
		print("Failed to parse JSON!")
		return
		
	return json.data
