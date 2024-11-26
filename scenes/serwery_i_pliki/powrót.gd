extends Button

func _ready() -> void:
	# Łączenie sygnału `pressed` przycisku z funkcją `_on_pressed`
	connect("pressed", Callable(self, "_on_pressed"))
