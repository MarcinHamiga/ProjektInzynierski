extends MarginContainer

signal menu_button_pressed
signal exit_button_pressed

@onready var score: RichTextLabel = $GameOverVBox/Score 

func _on_menu_button_pressed() -> void:
	menu_button_pressed.emit()


func _on_exit_button_pressed() -> void:
	exit_button_pressed.emit()


func set_score(score: int) -> void:
	self.score.text = '[center]Wynik: %d[/center]' % [score]
