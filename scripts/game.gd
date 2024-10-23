extends Node

var state_manager: Node
var scene_manager: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.state_manager = $StateManager
	self.scene_manager = $SceneManager


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var state = self.state_manager.get_state()
	if state == self.state_manager.GameState.MAIN_MENU:
		print(delta)
		pass
	elif state == self.state_manager.GameState.GAME:
		print(delta)
		pass
	else:
		print(delta)
		pass
	pass
