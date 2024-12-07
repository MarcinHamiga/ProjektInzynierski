extends MarginContainer

signal value_changed
signal back_pressed
var master_volume: Node
var music_volume: Node
var effect_volume: Node


func _ready() -> void:
	self.master_volume = $SettingsHBox/SettingsPanel/SettingsPanelMargin/SettingsFieldsAndButtonVBox/SettingsPanelVBox/MasterVolume
	self.music_volume = $SettingsHBox/SettingsPanel/SettingsPanelMargin/SettingsFieldsAndButtonVBox/SettingsPanelVBox/MusicVolume
	self.effect_volume = $SettingsHBox/SettingsPanel/SettingsPanelMargin/SettingsFieldsAndButtonVBox/SettingsPanelVBox/EffectVolume
	
	self.read_settings_from_file()

func _on_master_volume_value_changed(value: float) -> void:
	value_changed.emit(value, "Master")


func _on_music_volume_value_changed(value: float) -> void:
	value_changed.emit(value, "Music")


func _on_effect_volume_value_changed(value: float) -> void:
	value_changed.emit(value, "Effect")

func refresh_values() -> void:
	var master_index = AudioServer.get_bus_index("Master")
	var master_bus_volume = AudioServer.get_bus_volume_db(master_index)
	var linear_master_volume = db_to_linear(master_bus_volume)
	self.master_volume.set_text("Głośność główna %d%%" % [linear_master_volume * 100])
	self.master_volume.set_value(floor(linear_master_volume * 100))
	
	var music_index = AudioServer.get_bus_index("Music")
	var music_bus_volume = AudioServer.get_bus_volume_db(music_index)
	var linear_music_volume = db_to_linear(music_bus_volume)
	self.music_volume.set_text("Głośność muzyki %d%%" % [linear_music_volume * 100])
	self.music_volume.set_value(floor(linear_music_volume * 100))
	
	
	var effect_index = AudioServer.get_bus_index("Effect")
	var effect_bus_volume = AudioServer.get_bus_volume_db(effect_index)
	var linear_effect_volume = db_to_linear(effect_bus_volume)
	self.effect_volume.set_text("Głośność dźwięków %d%%" % [linear_effect_volume * 100])
	self.effect_volume.set_value(floor(linear_effect_volume * 100))	


func _on_back_pressed() -> void:
	Globals.play_sound.emit('click')
	back_pressed.emit()
	self.save_settings_to_file()


func save_settings_to_file() -> void:
	var master_index = AudioServer.get_bus_index("Master")
	var music_index = AudioServer.get_bus_index("Music")
	var effect_index = AudioServer.get_bus_index("Effect")
	
	var master_vol_db = AudioServer.get_bus_volume_db(master_index)
	var music_vol_db = AudioServer.get_bus_volume_db(music_index)
	var effect_vol_db = AudioServer.get_bus_volume_db(effect_index)
	
	var config_data = {
		"master_volume": floor(db_to_linear(master_vol_db) * 100),
		"music_volume": floor(db_to_linear(music_vol_db) * 100),
		"effect_volume": floor(db_to_linear(effect_vol_db) * 100)
	}
	
	var json_data = JSON.stringify(config_data, "\t")
	
	var file = FileAccess.open("res://config/settings.json", FileAccess.WRITE)
	if file:
		file.store_string(json_data)
		file.close()
	else:
		print("Error creating a file")


func read_settings_from_file() -> void:
	var file_data = Globals.load_json("res://config/settings.json")
	if file_data:
		value_changed.emit(file_data['master_volume'], "Master")
		value_changed.emit(file_data['music_volume'], "Music")
		value_changed.emit(file_data['effect_volume'], "Effect")
	else:
		value_changed.emit(100, "Master")
		value_changed.emit(100, "Music")
		value_changed.emit(100, "Effect")
	
	self.refresh_values()
