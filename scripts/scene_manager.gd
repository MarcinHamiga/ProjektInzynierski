extends Node

var current_scene: Node
var scene_tree: Array[Node]
var game_scenes: CanvasLayer
var ui: CanvasLayer
var datetime_label: RichTextLabel

signal scene_changed
signal scene_hidden

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.game_scenes = $GameScenes
	self.scene_tree = self.game_scenes.get_children()
	self.ui = $UI
	self.datetime_label = $UI/TaskBarContainer/TaskBarIcons/DateTime

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


func _on_state_manager_request_hide_ui() -> void:
	self.hide_ui()


func _on_state_manager_request_show_ui() -> void:
	self.show_ui()
