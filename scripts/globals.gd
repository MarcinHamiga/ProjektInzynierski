extends Node

enum GameState { MAIN_MENU, GAME, MENU_SETTINGS, INGAME_MENU, INGAME_TASK, GAME_OVER }
enum Tasks { NONE, LOGIN_CHECK, S_P }

signal play_sound
signal play_song

# Login rule keys
const PAS1: String = "PAS1"
const PAS2: String = "PAS2"
const PAS3: String = "PAS3"
const PAS4: String = "PAS4"
const PAS5: String = "PAS5"
const PAS6: String = "PAS6"
const PAS7: String = "PAS7"

const main_menu_song: AudioStream = preload("res://audio/music/Firewall Anthem.mp3")
const ingame_song: AudioStream = preload("res://audio/music/Firewall Bound.mp3")
const click_sound: AudioStream = preload("res://audio/sounds/switch-20.wav")

const song_atlas: Dictionary = {
	"main_menu": main_menu_song,
	"ingame": ingame_song
}

const sound_atlas: Dictionary = {
	"click": click_sound
}

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
