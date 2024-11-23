extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed():
	# Znalezienie elementu nadrzędnego `Message` i jego ukrycie
	var parent_message = get_parent().get_node("Email")
	if parent_message:
		parent_message.visible = false
	
	# Ładowanie i dodawanie instancji sceny `install_permission.tscn`
	var install_permission = load("res://scenes/serwery_i_pliki/install_permission.tscn")
	get_tree().root.add_child(install_permission.instantiate())  # Dodanie instancji do głównej sceny (nakładka)
