extends Button

func _ready() -> void:
	# Łączenie sygnału `pressed` przycisku z funkcją `_on_pressed`
	connect("pressed", Callable(self, "_on_pressed"))

func _on_pressed() -> void:
	# Usuwanie bieżącej sceny (Email.tscn) z drzewa
	var current_scene = get_tree().current_scene
	if current_scene:
		current_scene.queue_free()  # Usunięcie bieżącej sceny (Email.tscn)
	
	# Dodanie sceny `email_box.tscn` jako głównej sceny
	var email_box_scene = preload("res://scenes/serwery_i_pliki/email_box.tscn").instantiate()
	get_tree().root.add_child(email_box_scene)
	get_tree().current_scene = email_box_scene  # Ustawienie nowej sceny jako głównej
