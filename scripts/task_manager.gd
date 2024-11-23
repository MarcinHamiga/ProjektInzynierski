extends Node


@export var password_rules_filepath: String = "res://rules/password_rules.json"
@export var current_password_rule: String = "PAS1"
@export var time_until_next_task: float = 5
@export var time_until_task_expires: float = 120

signal ready_login_screen
signal add_strike
signal task_complete
signal new_task
signal resume_task

var task_time_left_timer: Timer
var next_task_timer: Timer
var current_task: Globals.Tasks
var is_password_correct: bool
var is_tfa_correct: bool
var rules_dict: Dictionary
var current_tfa_rule: String

var _filter: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	self.task_time_left_timer = $TaskTimeLeftTimer
	self.task_time_left_timer.wait_time = self.time_until_task_expires
	self.task_time_left_timer.one_shot = true
	self.next_task_timer = $NextTaskTimer
	self.next_task_timer.wait_time = self.time_until_next_task
	self.next_task_timer.one_shot = true
	self._load_password_regex_from_file()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _get_tfa_status() -> bool:
	var roll = randi_range(1, 100)
	match self.current_password_rule:
		"PAS1", "PAS2", "PAS3":
			return true
		"PAS4", "PAS5":
			if roll <= 25:
				return false
			return true
		"PAS6", "PAS7":
			if roll <= 35:
				return false
			return true
		_:
			return true


func _get_password_status() -> bool:
	var roll = randi_range(1, 100)
	match current_password_rule:
		"PAS1":
			if roll <= 15:
				return false
			return true
		"PAS2":
			if roll <= 18:
				return false
			return true
		"PAS3":
			if roll <= 25:
				return false
			return true
		"PAS4":
			if roll <= 30:
				return false
			return true
		"PAS5", "PAS6", "PAS7":
			if roll <= 35:
				return false
			return true
		_:
			return true


func _load_password_regex_from_file() -> void:
	for entry in Globals.load_json(self.password_rules_filepath):
		var regex: RegEx = RegEx.new()
		regex.compile(entry.regex)
		self.rules_dict[entry.id] = regex
	print(self.rules_dict)


func _get_password(_is_correct: bool = true) -> String:
	var data: Array
	if _is_correct:
		var filePath: String = "res://passwords_data/" + self.current_password_rule + ".json"
		data = Globals.load_json(filePath)
	else:
		var fileNumber = self.current_password_rule.substr(3).to_int()
		var filePath: String = "res://passwords_data/PAS" + str(randi_range(0, fileNumber - 1)) + ".json"
		data = Globals.load_json(filePath)
	var index: int = randi_range(0, data.size() - 1)
	return self._shuffle_password(data[index])


func _shuffle_password(password: String) -> String:
	var password_array: Array = password.split("")
	password_array.shuffle()
	var output = ""
	for _char in password_array:
		output += _char
	return output


func _verify_password(password: String) -> bool:
	if current_password_rule in rules_dict:
		var match = rules_dict[current_password_rule].search(password)
		return match != null
	else:
		print("Rule not found for:", current_password_rule)
		return false


func get_login_screen_data() -> void:
	var data = {}
	data['login'] = "kowal123"
	self.is_password_correct = self._get_password_status()
	var password = self._get_password(self.is_password_correct)

	if not self.is_password_correct or self._verify_password(password):
		data['is_password_correct'] = self.is_password_correct
	else:
		self.is_password_correct = false
		data['is_password_correct'] = false

	data['password'] = password
	
	self.is_tfa_correct = self._get_tfa_status()

	print(data)
	ready_login_screen.emit(data)


func _on_acceptance_component_accept_pressed() -> void:
	match self.current_task:
		Globals.Tasks.NONE:
			pass
		Globals.Tasks.LOGIN_CHECK:
			if self.is_password_correct and self.is_tfa_correct:
				task_complete.emit(true)
			else:
				task_complete.emit(false)
				add_strike.emit()
	self.next_task_timer.start()
	self.task_time_left_timer.stop()


func _on_acceptance_component_decline_pressed() -> void:
	match self.current_task:
		Globals.Tasks.NONE:
			pass
		Globals.Tasks.LOGIN_CHECK:
			if self.is_password_correct and self.is_tfa_correct:
				add_strike.emit()
				task_complete.emit(false)
			else:
				task_complete.emit(true)
	self.next_task_timer.start()
	self.task_time_left_timer.stop()


func _on_task_time_left_timer_timeout() -> void:
	add_strike.emit()
	task_complete.emit(false)
	self.current_task = Globals.Tasks.NONE
	self.next_task_timer.start()


func _on_game_start_new_game() -> void:
	self.next_task_timer.start()


func pause_timers() -> void:
	self.next_task_timer.paused = true
	self.task_time_left_timer.paused = true


func unpause_timers() -> void:
	self.next_task_timer.paused = false
	self.task_time_left_timer.paused = false


func stop_timers() -> void:
	self.next_task_timer.stop()
	self.task_time_left_timer.stop()


func _on_next_task_timer_timeout() -> void:
	print("New Task emitted")
	self.current_task = Globals.Tasks.LOGIN_CHECK
	self.get_login_screen_data()
	new_task.emit(self.current_task)
	self.task_time_left_timer.start()


func _on_game_new_day(day: int) -> void:
	match day:
		4:
			self.current_password_rule = Globals.PAS2
		8:
			self.current_password_rule = Globals.PAS3
		12:
			self.current_password_rule = Globals.PAS4
		16:
			self.current_password_rule = Globals.PAS5
		20:
			self.current_password_rule = Globals.PAS6
		24:
			self.current_password_rule = Globals.PAS7
		_:
			pass
	print(self.current_password_rule)


func _on_game_game_over() -> void:
	self.stop_timers()
	self.current_task = Globals.Tasks.NONE


func _on_state_manager_request_pause_ticks() -> void:
	self.pause_timers()


func _on_state_manager_request_resume_ticks() -> void:
	self.unpause_timers()


func _on_state_manager_resume_task() -> void:
	resume_task.emit(self.current_task)
