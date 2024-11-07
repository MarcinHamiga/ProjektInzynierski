extends Node

@export var game_state: Globals.GameState
 
signal state_changed
signal new_scene

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

	elif (
		self.game_state == Globals.GameState.INGAME_MENU \
		and event.is_action_pressed("MainMenuKey")
	):
		self.change_state(Globals.GameState.GAME)


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
		Globals.GameState.GAME:
			new_scene.emit("GameScreen")
		Globals.GameState.INGAME_MENU:
			new_scene.emit("IngameMenu")


func get_state() -> Globals.GameState:
	return self.game_state


func _on_game_change_state(new_state: Globals.GameState) -> void:
	self.change_state(new_state)
	print("State changed to: %s" % [new_state])
