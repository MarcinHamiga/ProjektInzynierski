extends Node

var current_scene: Node
var scene_tree: Array[Node]
var game_scenes: CanvasLayer
var ui: CanvasLayer
var login_scene: MarginContainer
var datetime_label: RichTextLabel
var intro: VideoStreamPlayer
var controls: MarginContainer
var game_over: MarginContainer

signal scene_changed
signal scene_hidden
signal enable_buttons
signal disable_buttons
signal pause_game
signal unpause_game
signal write_to_match_info

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.game_scenes = $GameScenes
	self.scene_tree = self.game_scenes.get_children()
	self.ui = $UI
	self.datetime_label = $UI/TaskBarContainer/TaskBarIcons/DateTime
	self.intro = $Intro
	self.controls = $UI/AcceptanceComponent
	self.login_scene = $GameScenes/LoginData
	self.game_over = $GameScenes/GameOver
	enable_buttons.connect(self.controls.enable_buttons)
	disable_buttons.connect(self.controls.disable_buttons)
	write_to_match_info.connect(self.controls.write_to_match_info)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hide_scene(scene: Node) -> void:
	scene.hide()
	scene_hidden.emit(scene)
	
func show_scene(scene: Node) -> void:
	scene.show()
	
	
func set_current_scene(scene_name: String) -> void:
	if not self.scene_tree:
		self.scene_tree = self.game_scenes.get_children()
	for scene in self.scene_tree:
		if scene.name == scene_name:
			print("Scene name: %s" % [scene.name])
			self.current_scene = scene
			self.show_scene(self.current_scene)
			self.hide_unused_scenes()
			scene_changed.emit(scene)
	
func hide_unused_scenes() -> void:
	if not self.scene_tree:
		self.scene_tree = self.game_scenes.get_children()
	for scene in self.scene_tree:
		if scene.name != current_scene.name and scene.name != "BG":
			self.hide_scene(scene)


func _on_state_manager_new_scene(scene_name: String) -> void:
	self.set_current_scene(scene_name)


func _on_game_update_datetime(day: int, hour: int, minute: int) -> void:
	self.datetime_label.text = "[center]Dzień %d, %02d:%02d[/center]" % [day, hour, minute]


func hide_ui():
	self.ui.visible = 0


func show_ui():
	self.ui.visible = 1


func hide_game_scenes():
	self.game_scenes.visible = 0
	
	
func show_game_scenes():
	self.game_scenes.visible = 1

func _on_state_manager_request_hide_ui() -> void:
	self.hide_ui()


func _on_state_manager_request_show_ui() -> void:
	self.show_ui()


func _on_game_intro() -> void:
	self.hide_ui()
	self.hide_game_scenes()
	self.intro.play()


func _on_intro_finished() -> void:
	self.show_game_scenes()
	Globals.play_song.emit("main_menu")


func _on_state_manager_request_activate_control_buttons() -> void:
	enable_buttons.emit()


func show_task(task: Globals.Tasks) -> void:
	match task:
		Globals.Tasks.LOGIN_CHECK:
			self.set_current_scene("LoginData")
			enable_buttons.emit()
		Globals.Tasks.S_P:
			self.set_current_scene("EmailBox")
			disable_buttons.emit()
		_:
			pass


func _on_task_manager_new_task(task: Globals.Tasks) -> void:
	print("New task")
	self.show_task(task)


func _on_task_manager_task_complete(correct_answer: bool) -> void:
	print("Answer: " + str(correct_answer))
	if correct_answer:
		write_to_match_info.emit("[center][color=green]Dobrze[/color][/center]")
	else:
		write_to_match_info.emit("[center][color=red]Źle[/color][/center]")
	disable_buttons.emit()


func _on_task_manager_ready_login_screen(data: Dictionary) -> void:
	self.login_scene.set_login(data['login'])
	self.login_scene.set_password(data['password'])


func _on_game_update_strikes(strikes: int) -> void:
	self.controls.write_to_strikes(strikes)


func _on_task_manager_resume_task(task: Globals.Tasks) -> void:
	self.show_task(task)


func _on_game_start_new_game() -> void:
	self.controls.reset()


func _on_task_manager_request_enable_controls() -> void:
	enable_buttons.emit()
