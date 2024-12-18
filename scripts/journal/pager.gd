extends Control

# Zmienna przechowująca treści stron
var pager_name = ""
var pages_content = []
var current_page_index = 0
var journal_data = {}
# Odnośniki do elementów interfejsu
@onready var text_edit = $VBoxContainer/RichTextLabel
@onready var prev_button = $VBoxContainer/HBoxContainer/PrevButton
@onready var next_button = $VBoxContainer/HBoxContainer/NextButton

func _ready():
	journal_data = Globals.load_json("res://Dane/journal.json")

func add_pages():
	for chapter in journal_data["chapters"]:
		if chapter["title"] == pager_name:
			for i in range(chapter["pages"].size()):
				pages_content.append(chapter["pages"][i]["content"])
			text_edit.text = pages_content[current_page_index]

func display():
	text_edit.text = pages_content[current_page_index]

func _on_prev_button_pressed() -> void:
	if pages_content.size() == 0:
		return
	current_page_index -= 1
	if current_page_index < 0:
		current_page_index = pages_content.size() - 1
	display()

func _on_next_button_pressed() -> void:
	if pages_content.size() == 0:
		return
	current_page_index += 1
	if current_page_index >= pages_content.size():
		current_page_index = 0
	display()
