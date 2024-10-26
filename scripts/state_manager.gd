extends Node

enum GameState { MAIN_MENU, GAME }
@export var game_state: GameState
 
signal state_changed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.change_state(GameState.MAIN_MENU)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match game_state:
		GameState.MAIN_MENU:
			pass
		GameState.GAME:
			pass


func change_state(new_state: GameState): 
	if game_state != new_state:
		self.game_state = GameState
		state_changed.emit(new_state)

func handle_state_change(new_state: GameState):
	match new_state:
		GameState.MAIN_MENU:
			pass
		GameState.GAME:
			pass

func on_change_state(new_state: GameState):
	self.change_state(new_state)


func get_state() -> Array:
	return [self.game_state, str(self.game_state)]
