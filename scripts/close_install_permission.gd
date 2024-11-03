extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	var message_node = get_tree().root.get_node("Message")
	if message_node:
		message_node.visible = true  # Przywrócenie widoczności elementu Message

	# Usunięcie bieżącej nakładki (sceny install_permission)
	get_parent().queue_free()  # Usunięcie rodzica, czyli nakładki
