extends Node

@export var game_state: Globals.GameState

var first_click_slot: Node
var second_click_slot: Node
var was_doing_task: bool
var was_ingame_menu: bool

var states = {
	Globals.GameState.GAME: self.change_state_to_game,
	Globals.GameState.MAIN_MENU: self.change_state_to_main_menu,
	Globals.GameState.INGAME_MENU: self.change_state_to_ingame_menu,
	Globals.GameState.MENU_SETTINGS: self.change_state_to_settings,
	Globals.GameState.INGAME_TASK: self.change_state_to_ingame_task,
	Globals.GameState.GAME_OVER: self.change_state_to_game_over
}
 
signal state_changed
signal new_scene
signal request_hide_ui
signal request_show_ui
signal request_pause_ticks
signal request_resume_ticks
signal request_activate_control_buttons
signal resume_task

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.change_state(Globals.GameState.MAIN_MENU)
	self.was_doing_task = false


func _input(event):
	if (
		self.game_state != Globals.GameState.MAIN_MENU \
		and self.game_state != Globals.GameState.INGAME_MENU \
		and self.game_state != Globals.GameState.MENU_SETTINGS
		and event.is_action_pressed("MainMenuKey")
	):
		self.change_state(Globals.GameState.INGAME_MENU)
		request_pause_ticks.emit()

	elif (
		self.game_state == Globals.GameState.INGAME_MENU \
		and event.is_action_pressed("MainMenuKey")
	):
		self.change_state(Globals.GameState.GAME)
		request_resume_ticks.emit()
	
	elif (
		self.game_state == Globals.GameState.MENU_SETTINGS \
		and self.was_ingame_menu
		and event.is_action_pressed("MainMenuKey")
	):
		self.change_state(Globals.GameState.INGAME_MENU)
	
	elif (
		self.game_state == Globals.GameState.MENU_SETTINGS \
		and not self.was_ingame_menu \
		and event.is_action_pressed("MainMenuKey")
	):
		self.change_state(Globals.GameState.MAIN_MENU)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match game_state:
		Globals.GameState.MAIN_MENU:
			pass
		Globals.GameState.GAME:
			pass


func change_state(new_state: Globals.GameState): 
	if game_state != new_state and game_state != Globals.GameState.GAME_OVER:
		self.handle_state_change(new_state)
		state_changed.emit(self.game_state)
	elif new_state == Globals.GameState.MAIN_MENU and game_state == Globals.GameState.GAME_OVER:
		self.handle_state_change(new_state)
		state_changed.emit(self.game_state)

func change_state_to_main_menu():
	self.was_doing_task = false
	new_scene.emit("MainMenuMargin")
	request_pause_ticks.emit()
	request_hide_ui.emit()
	self.game_state = Globals.GameState.MAIN_MENU


func change_state_to_game():
	new_scene.emit("GameScreen")
	request_show_ui.emit()
	request_resume_ticks.emit()
	self.game_state = Globals.GameState.GAME


func change_state_to_ingame_menu():
	if self.game_state == Globals.GameState.INGAME_TASK:
		self.was_doing_task = true
	new_scene.emit("IngameMenu")
	request_pause_ticks.emit()
	request_hide_ui.emit()
	self.game_state = Globals.GameState.INGAME_MENU


func change_state_to_ingame_task():
	self.was_doing_task = false
	request_activate_control_buttons.emit()
	self.game_state = Globals.GameState.INGAME_TASK
	resume_task.emit()


func change_state_to_game_over():
	new_scene.emit("GameOver")
	self.was_doing_task = false
	request_pause_ticks.emit()
	request_hide_ui.emit()
	self.game_state = Globals.GameState.GAME_OVER

func change_state_to_settings():
	if self.game_state == Globals.GameState.MAIN_MENU:
		self.was_ingame_menu = false
	elif self.game_state == Globals.GameState.INGAME_MENU:
		self.was_ingame_menu = true
	new_scene.emit("Settings")
	self.game_state = Globals.GameState.MENU_SETTINGS

func handle_state_change(new_state: Globals.GameState):
	self.states[new_state].call()


func get_state() -> Globals.GameState:
	return self.game_state


func _on_game_change_state(new_state: Globals.GameState) -> void:
	self.change_state(new_state)
	print("State changed to: %s" % [new_state])


func _on_task_manager_new_task(task: Globals.Tasks) -> void:
	print("New task")
	self.change_state(Globals.GameState.INGAME_TASK)


func _on_task_manager_task_complete(correct_answer: bool) -> void:
	self.change_state(Globals.GameState.GAME)


func _on_game_game_over() -> void:
	self.change_state(Globals.GameState.GAME_OVER)


func _on_settings_back_pressed() -> void:
	if self.was_ingame_menu:
		self.change_state(Globals.GameState.INGAME_MENU)
	else:
		self.change_state(Globals.GameState.MAIN_MENU)
