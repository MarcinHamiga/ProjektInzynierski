extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Obsługuje kliknięcie przycisku
func _on_pressed():
	# Znalezienie elementu nadrzędnego `Message` i jego ukrycie
	var parent_message = get_parent().get_node("Email")
	if parent_message:
		parent_message.visible = false
	
	# Ładowanie i dodawanie instancji sceny `install_permission.tscn`
	var install_permission_scene = load("res://scenes/serwery_i_pliki/install_permission.tscn")
	var install_permission_instance = install_permission_scene.instantiate()

	# Ustawianie metadanych z przekazanym ID rekordu (z poprzedniej sceny)
	#var record_id = get_meta("record_id", -1)
	#if record_id != -1:
		#install_permission_instance.set_meta("record_id", record_id)
	#else:
		#print("Brak przekazanego record_id w metadanych!")

	# Dodanie instancji sceny do głównej sceny
	get_tree().root.add_child(install_permission_instance)

	# Opcjonalnie, możesz ustawić opcję, by cała poprzednia scena była ukryta
	# get_tree().current_scene.hide()
