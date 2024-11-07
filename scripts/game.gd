extends Node


@export var tickrate: float = 30.0
@export var timerate: int = 30
var state_manager: Node
var scene_manager: Node
var game_state_enum
var tick_timer: Timer
var strike_time: Timer
var strikes: int
var day: int
var hour: int
var minute: int

signal change_state
signal update_datetime

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.state_manager = $StateManager
	self.scene_manager = $SceneManager
	self.tick_timer = $Tick
	self.tick_timer.wait_time = self.tickrate
	self.strike_time = $StrikeTimer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func new_game():
	self.strikes = 0
	self.day = 1
	self.hour = 8
	self.minute = 0
	update_datetime.emit(self.day, self.hour, self.minute)
	self.tick_timer.start()
	


func _on_main_menu_exit_button_pressed() -> void:
	get_tree().quit()


func _on_main_menu_new_game_button_pressed() -> void:
	await self.new_game()
	change_state.emit(Globals.GameState.GAME)


func _on_main_menu_settings_button_pressed() -> void:
	change_state.emit(Globals.GameState.MENU_SETTINGS)


func _on_ingame_menu_continue_button_pressed() -> void:
	change_state.emit(Globals.GameState.GAME)


func _on_ingame_menu_settings_button_pressed() -> void:
	change_state.emit(Globals.GameState.MENU_SETTINGS)


func _on_ingame_menu_exit_button_pressed() -> void:
	self.get_tree().quit()


func _on_tick_timeout() -> void:
	self.minute += self.timerate
	if self.minute >= 60:
		self.minute = 0
		self.hour += 1
		if self.hour >= 24:
			self.hour = 0
			self.day += 1
	update_datetime.emit(day, hour, minute)
	

func pause_ticks():
	self.tick_timer.stop()


func resume_ticks():
	self.tick_timer.start()


func _on_state_manager_request_pause_ticks() -> void:
	self.pause_ticks()


func _on_state_manager_request_resume_ticks() -> void:
	self.resume_ticks()


func _on_os_button_pressed() -> void:
	change_state.emit(Globals.GameState.INGAME_MENU)


func _on_ingame_menu_exit_to_menu_button_pressed() -> void:
	change_state.emit(Globals.GameState.MAIN_MENU)
