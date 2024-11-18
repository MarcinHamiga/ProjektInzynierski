extends Node

@export var game_state: Globals.GameState
var first_click_slot: Node
var second_click_slot: Node
 
signal state_changed
signal new_scene
signal request_hide_ui
signal request_show_ui
signal request_pause_ticks
signal request_resume_ticks
signal request_activate_control_buttons
signal request_disable_control_buttons
signal pause_game
signal unpause_game
signal lawful_accept
signal wrong_accept
signal unlawful_decline
signal correct_decline

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.change_state(Globals.GameState.MAIN_MENU)

func _input(event):
	if (
		self.game_state != Globals.GameState.MAIN_MENU \
		and self.game_state != Globals.GameState.INGAME_MENU \
		and event.is_action_pressed("MainMenuKey")
	):
		self.change_state(Globals.GameState.INGAME_MENU)
		pause_game.emit()

	elif (
		self.game_state == Globals.GameState.INGAME_MENU \
		and event.is_action_pressed("MainMenuKey")
	):
		self.change_state(Globals.GameState.GAME)
		unpause_game.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match game_state:
		Globals.GameState.MAIN_MENU:
			pass
		Globals.GameState.GAME:
			pass


func change_state(new_state: Globals.GameState): 
	if game_state != new_state:
		self.game_state = new_state
		state_changed.emit(self.game_state)
		self.handle_state_change()


func handle_state_change():
	match self.game_state:
		Globals.GameState.MAIN_MENU:
			new_scene.emit("MainMenuMargin")
			request_pause_ticks.emit()
			request_hide_ui.emit()
			pause_game.emit()
		Globals.GameState.GAME:
			new_scene.emit("GameScreen")
			request_show_ui.emit()
			request_resume_ticks.emit()
			unpause_game.emit()
		Globals.GameState.INGAME_MENU:
			new_scene.emit("IngameMenu")
			request_pause_ticks.emit()
			request_hide_ui.emit()
			pause_game.emit()
		Globals.GameState.INGAME_TASK:
			request_activate_control_buttons.emit()


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
