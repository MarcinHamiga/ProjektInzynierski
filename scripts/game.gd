extends Node


@export var tickrate: float = 1.25
@export var timerate: int = 15
@export var strike_fade_rate: float = 120
@export var _intro: bool = true

var state_manager: Node
var scene_manager: Node
var task_manager: Node
var tick_timer: Timer
var strike_timer: Timer
var strikes: int
var day: int
var hour: int
var minute: int
var score: int = 0

signal change_state
signal update_datetime
signal start_new_game
signal new_day
signal game_over
signal update_strikes
signal intro
signal update_score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.state_manager = $StateManager
	self.scene_manager = $SceneManager
	self.task_manager = $TaskManager
	self.tick_timer = $Tick
	self.tick_timer.wait_time = self.tickrate
	self.strike_timer = $StrikeTimer
	self.strike_timer.stop()
	self.strike_timer.wait_time = self.strike_fade_rate
	self.strike_timer.autostart = false
	self.strike_timer.one_shot = true
	if self._intro:
		intro.emit()
	else:
		$SceneManager/Intro.finished.emit()

func new_game():
	self.strikes = 0
	self.day = 1
	self.hour = 8
	self.minute = 0
	self.score = 0
	update_datetime.emit(self.day, self.hour, self.minute)
	start_new_game.emit()
	self.tick_timer.start()


func _on_main_menu_exit_button_pressed() -> void:
	Globals.play_sound.emit("click")
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()


func _on_main_menu_new_game_button_pressed() -> void:
	Globals.play_sound.emit("click")
	Globals.play_song.emit("ingame")
	self.new_game()
	change_state.emit(Globals.GameState.GAME)


func _on_main_menu_settings_button_pressed() -> void:
	Globals.play_sound.emit("click")
	change_state.emit(Globals.GameState.MENU_SETTINGS)


func _on_ingame_menu_continue_button_pressed() -> void:
	Globals.play_sound.emit("click")
	change_state.emit(Globals.GameState.GAME)


func _on_ingame_menuv_settings_button_pressed() -> void:
	Globals.play_sound.emit("click")
	change_state.emit(Globals.GameState.MENU_SETTINGS)


func _on_ingame_menu_exit_button_pressed() -> void:
	Globals.play_sound.emit("click")
	await get_tree().create_timer(0.5).timeout
	self.get_tree().quit()


func _on_tick_timeout() -> void:
	self.minute += self.timerate
	if self.minute >= 60:
		self.minute = 0
		self.hour += 1
		if self.hour >= 24:
			self.hour = 0
			self.day += 1
			new_day.emit(self.day)
	update_datetime.emit(day, hour, minute)

func pause_ticks():
	self.tick_timer.paused = true
	self.strike_timer.paused = true


func resume_ticks():
	self.tick_timer.paused = false
	self.strike_timer.paused = false


func stop_ticks():
	self.tick_timer.stop()
	self.strike_timer.stop()


func _on_state_manager_request_pause_ticks() -> void:
	self.pause_ticks()


func _on_state_manager_request_resume_ticks() -> void:
	self.resume_ticks()


func _on_os_button_pressed() -> void:
	Globals.play_sound.emit("click")
	change_state.emit(Globals.GameState.INGAME_MENU)


func _on_ingame_menu_exit_to_menu_button_pressed() -> void:
	Globals.play_sound.emit("click")
	Globals.play_song.emit("main_menu")
	change_state.emit(Globals.GameState.MAIN_MENU)


func _on_task_manager_add_strike() -> void:
	self.strikes += 1
	if self.strike_timer.is_stopped():
		self.strike_timer.start()
	if self.strikes > 3:
		print("Strikes limit exceeded. Game ending")
		game_over.emit()
	update_strikes.emit(self.strikes)


func _on_strike_timer_timeout() -> void:
	self.strikes -= 1
	if self.strikes > 0:
		self.strike_timer.start()
	update_strikes.emit(self.strikes)

func add_score() -> int:
	self.score += 10
	self.scene_manager.set_score(self.score)
	return self.score
	
