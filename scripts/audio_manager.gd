extends Node

var music_player: AudioStreamPlayer
var effect_player: AudioStreamPlayer

func _ready() -> void:
	self.music_player = $MusicPlayer
	self.music_player.bus = "Music"
	self.music_player.stream = Globals.main_menu_song
	self.effect_player = $EffectPlayer
	self.effect_player.bus = "Effect"
	self.effect_player.stream = Globals.click_sound
	Globals.play_song.connect(play_song)
	Globals.play_sound.connect(play_sound)


func play_song(name: String, time: float = 0.0) -> void:
	if self.music_player.stream == Globals.song_atlas[name]:
		self.music_player.play(time)
	else:
		self.music_player.stream = Globals.song_atlas[name]
		self.music_player.play(time)

func play_sound(name: String, time: float = 0.0) -> void:
	self.effect_player.pitch_scale = randf_range(0.98, 1.02)	
	# Play the sound
	if self.effect_player.stream == Globals.sound_atlas[name]:
		self.effect_player.play(time)
	else:
		self.effect_player.stream = Globals.sound_atlas[name]
		self.effect_player.play(time)


func _on_music_player_finished() -> void:
	self.music_player.play(0)


func _on_settings_value_changed(value: float, bus_name: String) -> void:
	value = linear_to_db(value / 100)
	var bus_idx = AudioServer.get_bus_index(bus_name)
	print("Current %s bus volume in db: %d" % [bus_name, value])
	AudioServer.set_bus_volume_db(bus_idx, value)
