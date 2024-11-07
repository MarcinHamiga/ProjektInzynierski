extends MarginContainer

signal continue_button_pressed
signal settings_button_pressed
signal exit_to_menu_button_pressed
signal exit_button_pressed

func _on_continue_pressed() -> void:
	continue_button_pressed.emit()


func _on_settings_pressed() -> void:
	settings_button_pressed.emit()


func _on_exit_pressed() -> void:
	exit_to_menu_button_pressed.emit()


func _on_exit_desktop_pressed() -> void:
	exit_button_pressed.emit()
