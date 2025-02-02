extends Control

# Zmienna przechowująca dane JSON
var journal_data = {}
var pagers = []

@onready var tab_container = $VBoxContainer/TabContainer
var current_page_index = 1

func _ready():
	journal_data = Globals.load_json("res://Dane/journal.json")
	add_tabs()
	tab_container.connect("tab_changed", Callable(self, "_on_tab_container_tab_changed"))

func add_tabs():
	var Pager = preload("res://scenes/journal/pager.tscn")
	
	for chapter in journal_data["chapters"]:
		var pager = Pager.instantiate()
		pager._ready()
		pager.pager_name = chapter["title"]
		pager.add_pages()
		pager.name = chapter["title"]
		tab_container.add_child(pager)
		pagers.append(pager)
		pager.display()
		
func _on_tab_container_tab_changed(tab: int) -> void:
	var chapter_name = tab_container.get_tab_title(tab)
	for pager in pagers:
		if pager.name == chapter_name:
			pager.display()
			return


func _on_button_pressed() -> void:
	Globals.play_sound.emit("click")
	tab_container.visible = not tab_container.visible
