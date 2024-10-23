extends Node

var current_scene: Node
var scene_tree: Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hide_scene(scene: Node) -> void:
	scene.hide()
	
func show_scene(scene: Node) -> void:
	scene.show()
	
	
func set_current_scene(scene_name: String) -> void:
	if not self.scene_tree:
		self.scene_tree = $GameScenes.get_children()
	for scene in self.scene_tree:
		if scene.name == scene_name:
			self.current_scene = scene
	
func hide_unused_scenes() -> void:
	if not self.scene_tree:
		self.scene_tree = $GamesScenes.get_children()
	for scene in self.scene_tree:
		if scene.name != current_scene.name:
			scene.hide()
			
