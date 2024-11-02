extends Control

var num_items := 10  # Liczba wierszy na liście

func _ready() -> void:
	var item_list = get_node("MessagesList")

	# Ikona do ustawienia w `ItemList` (zmień ścieżkę na swoją ikonę)
	var icon = load("res://icon.svg")

	# Przykładowe dane do wyświetlenia
	var names = ["Jan Kowalski", "Anna Nowak", "Piotr Zając", "Maria Wiśniewska", "Tomasz Nowicki"]
	var topics = ["Problem z aplikacją", "Pytanie o produkt", "Błąd w systemie", "Prośba o pomoc", "Sugestia"]
	var types = ["Serwis", "Zapytanie", "Błąd", "Wsparcie", "Inne"]

	for i in range(num_items):
		# Przygotowanie tekstu do wyświetlenia w wierszu
		var name = names[i % names.size()]
		var topic = topics[i % topics.size()]
		var request_type = types[i % types.size()]

		# Formatowanie tekstu dla danego wiersza
		var row_text = format_column(name, 20) + format_column(topic, 30) + request_type

		# Dodanie elementu do ItemList z ikoną i sformatowanym tekstem
		item_list.add_item(row_text)
		item_list.set_item_icon(item_list.get_item_count() - 1, icon)  # Ustawienie ikony dla bieżącego wiersza

# Funkcja do formatowania kolumny przez dodanie spacji do zadanej szerokości
func format_column(text: String, width: int) -> String:
	var padding := ""
	var padding_size := width - text.length()
	
	# Dodaj odpowiednią liczbę spacji
	for i in range(padding_size):
		padding += " "
		
	return text + padding
