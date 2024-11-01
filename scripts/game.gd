extends Node

var state_manager: Node
var scene_manager: Node
var game_state_enum
var day_timer: Timer
var strike_time: Timer
var strikes: int
var day: int

signal change_state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.state_manager = $StateManager
	self.scene_manager = $SceneManager
	self.day_timer = $DayTimer
	self.day_timer.wait_time = 120
	self.strike_time = $StrikeTimer
	self.strikes = 0
	self.day = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func new_game():
	self.strikes = 0
	self.day = 1
	self.day_timer.start()


func _on_main_menu_exit_button_pressed() -> void:
	get_tree().quit()


func _on_main_menu_new_game_button_pressed() -> void:
	print("Play Button Pressed")
	change_state.emit(Globals.GameState.GAME)


func _on_main_menu_settings_button_pressed() -> void:
	print("Settings button pressed")
