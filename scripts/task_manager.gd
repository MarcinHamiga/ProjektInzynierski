extends Node



@export var time_until_next_task: float = 5
@export var time_until_task_expires: float = 120

signal ready_login_screen
signal add_strike
signal task_complete
signal new_task
signal resume_task
signal request_enable_controls
signal generate_new_sites


var login_manager: Node
var task_time_left_timer: Timer
var next_task_timer: Timer
var current_task: Globals.Tasks
var is_password_correct: bool
var is_tfa_correct: bool
var is_record_correct: bool
var is_sites_correct: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	self.task_time_left_timer = $TaskTimeLeftTimer
	self.task_time_left_timer.wait_time = self.time_until_task_expires
	self.task_time_left_timer.one_shot = true
	self.next_task_timer = $NextTaskTimer
	self.next_task_timer.wait_time = self.time_until_next_task
	self.next_task_timer.one_shot = true
	self.login_manager = $LoginManager
	self.login_manager._load_password_regex_from_file()


func _on_acceptance_component_accept_pressed() -> void:
	Globals.play_sound.emit("click")
	var game = get_parent()
	match self.current_task:
		Globals.Tasks.NONE:
			pass
		Globals.Tasks.LOGIN_CHECK:
			if self.is_password_correct and self.is_tfa_correct:
				task_complete.emit(true)
				game.add_score()
			else:
				task_complete.emit(false)
				add_strike.emit()
		Globals.Tasks.S_P:
			if self.is_record_correct:
				task_complete.emit(true)
				game.add_score()
			else:
				task_complete.emit(false)
				add_strike.emit()
		Globals.Tasks.SITES:
			if self.is_sites_correct:
				task_complete.emit(true)
				game.add_score()
			else:
				task_complete.emit(false)
				add_strike.emit()
	self.next_task_timer.start()
	self.task_time_left_timer.stop()
	self.current_task = Globals.Tasks.NONE


func _on_acceptance_component_decline_pressed() -> void:
	Globals.play_sound.emit("click")
	var game = get_parent()
	match self.current_task:
		Globals.Tasks.NONE:
			pass
		Globals.Tasks.LOGIN_CHECK:
			if self.is_password_correct and self.is_tfa_correct:
				add_strike.emit()
				task_complete.emit(false)
			else:
				game.add_score()
				task_complete.emit(true)
		Globals.Tasks.S_P:
			if self.is_record_correct:
				add_strike.emit()
				task_complete.emit(false)
			else:
				game.add_score()
				task_complete.emit(true)
		Globals.Tasks.SITES:
			if self.is_sites_correct:
				add_strike.emit()
				task_complete.emit(false)
			else:
				game.add_score()
				task_complete.emit(true)
	self.next_task_timer.start()
	self.task_time_left_timer.stop()
	self.current_task = Globals.Tasks.NONE


func _on_task_time_left_timer_timeout() -> void:
	add_strike.emit()
	task_complete.emit(false)
	self.current_task = Globals.Tasks.NONE
	self.next_task_timer.start()


func _on_game_start_new_game() -> void:
	self.current_task = Globals.Tasks.NONE
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
	var roll = randi_range(1, 100)
	if (roll <= 1):
		self.current_task = Globals.Tasks.LOGIN_CHECK
		var data = self.login_manager.get_login_screen_data(ready_login_screen)
		self.is_password_correct = data['is_password_correct']
		self.is_tfa_correct = data['is_tfa_correct']
	elif (roll <= 99):
		self.current_task = Globals.Tasks.SITES
		generate_new_sites.emit()
	else:
		self.current_task = Globals.Tasks.S_P
		main_sip.regenerate.emit()
	
	new_task.emit(self.current_task)
	self.task_time_left_timer.start()


func _on_game_new_day(day: int) -> void:
	match day:
		4:
			self.login_manager.set_password_rule(Globals.PAS2)
		8:
			self.login_manager.set_password_rule(Globals.PAS3)
			self.login_manager.set_tfa_rule(Globals.TFA2)
		12:
			self.login_manager.set_password_rule(Globals.PAS4)
		16:
			self.login_manager.set_password_rule(Globals.PAS5)
			self.login_manager.set_tfa_rule(Globals.TFA3)
		20:
			self.login_manager.set_password_rule(Globals.PAS6)
			self.login_manager.set_tfa_rule(Globals.TFA4)
		24:
			self.login_manager.set_password_rule(Globals.PAS7)
			self.login_manager.set_tfa_rule(Globals.TFA5)
		_:
			pass
	print(self.login_manager.get_password_rule())
	print(self.login_manager.get_tfa_rule())


func _on_game_game_over() -> void:
	self.stop_timers()
	self.current_task = Globals.Tasks.NONE


func _on_state_manager_request_pause_ticks() -> void:
	self.pause_timers()


func _on_state_manager_request_resume_ticks() -> void:
	self.unpause_timers()


func _on_state_manager_resume_task() -> void:
	resume_task.emit(self.current_task)


func _on_email_box_new_record(is_correct: bool) -> void:
	self.is_record_correct = is_correct
	request_enable_controls.emit()


func _on_acceptance_component_get_time_left(update_method: Callable) -> void:
	if typeof(update_method) == TYPE_CALLABLE:
		if self.current_task != Globals.Tasks.NONE:
			update_method.call(
				self.task_time_left_timer.time_left, 
				self.task_time_left_timer.wait_time
			)
		else:
			update_method.call(
				self.next_task_timer.time_left,
				self.next_task_timer.wait_time,
				true
			)


func _on_sites_answer_sites(answer: bool) -> void:
	self.is_sites_correct = answer
