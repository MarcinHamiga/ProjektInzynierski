extends Node

var state_manager: Node
var scene_manager: Node
var day_timer: Timer
var strike_time: Timer
var strikes: int
var day: int

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


func new_game():
	self.strikes = 0
	self.day = 1
	self.day_timer.start()
