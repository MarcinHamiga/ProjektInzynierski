extends Node

@export var game_state: Globals.GameState
 
signal state_changed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.change_state(Globals.GameState.MAIN_MENU)


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

func handle_state_change(new_state: Globals.GameState):
	match new_state:
		Globals.GameState.MAIN_MENU:
			pass
		Globals.GameState.GAME:
			pass


func get_state() -> Globals.GameState:
	return self.game_state


func _on_game_change_state(new_state: Globals.GameState) -> void:
	self.change_state(new_state)
	print("State changed to: %s" % [new_state])
