extends Control
# Zmienna przechowująca treści stron
var pager_name = ""
var pages_content = []
var current_page_index = 0
var journal_data = {}
# Odnośniki do elementów interfejsu
@onready var text_edit = $MarginContainer/RichTextLabel
@onready var prev_button = $HBoxContainer/PrevButton
@onready var next_button = $HBoxContainer/NextButton
@onready var page_index_text = $HBoxContainer/PageIndex

func _ready():
	page_index_text.add_theme_font_size_override("normal_font_size", 32)
	journal_data = Globals.load_json("res://Dane/journal.json")

func add_pages():
	for chapter in journal_data["chapters"]:
		if chapter["title"] == pager_name:
			for i in range(chapter["pages"].size()):
				pages_content.append(chapter["pages"][i]["content"])
			text_edit.text = pages_content[current_page_index]

func display():
	page_index_text.text = '[center]' + str(current_page_index + 1) + '[/center]'
	text_edit.text = pages_content[current_page_index]

func _on_prev_button_pressed() -> void:
	Globals.play_sound.emit("click")
	print("prev_button_clicked")
	if pages_content.size() == 0:
		return
	print("has more than one page")
	current_page_index -= 1
	if current_page_index < 0:
		current_page_index = pages_content.size() - 1
	display()

func _on_next_button_pressed() -> void:
	Globals.play_sound.emit("click")
	print("next_button_clicked")
	if pages_content.size() == 0:
		return
	print("has more than one page")
	current_page_index += 1
	if current_page_index >= pages_content.size():
		current_page_index = 0
	display()
