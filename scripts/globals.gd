extends Node

enum GameState { MAIN_MENU, GAME, MENU_SETTINGS, INGAME_MENU, INGAME_TASK }
enum Tasks { NONE, LOGIN_CHECK }

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
