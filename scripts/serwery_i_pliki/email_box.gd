extends Control


func add_item():
	var vbox = $MessList/VBoxContainerr
	for x in range(10):
		var hbox = HBoxContainer.new()
		var texture_rect = TextureRect.new()
		texture_rect.texture = load("res://icon.svg")
		var label = Label.new()
		label.text = str("text" + str(x))
		hbox.add_child(texture_rect)
		hbox.add_child(label)
		$MessList/VBoxContainer.add_child(hbox)
	
var num_items := 10  # Liczba wierszy na liście

func _ready() -> void:
	add_item()

# Funkcja do formatowania kolumny przez dodanie spacji do zadanej szerokości
func format_column(text: String, width: int) -> String:
	var padding := ""
	var padding_size := width - text.length()
	
	# Dodaj odpowiednią liczbę spacji
	for i in range(padding_size):
		padding += " "
		
	return text + padding
