extends Control

signal new_game_button_pressed
signal settings_button_pressed
signal exit_button_pressed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	new_game_button_pressed.emit()


func _on_settings_pressed() -> void:
	settings_button_pressed.emit()


func _on_exit_pressed() -> void:
	exit_button_pressed.emit()
