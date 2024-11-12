extends Node

signal ready_login_screen

var current_task: Globals.Tasks
var is_password_correct: bool
var is_tfa_correct: bool
var rules_dict: Dictionary
var current_password_rule: String
var current_tfa_rule: String
var rules_filepath: String = "res://rules/password_rules.json"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	current_password_rule = "PAS1"
	self.load_password_regex_from_file()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_tfa_status(day: int) -> bool:
	var roll = randi_range(1, 100)
	if day < 25:
		return true
	elif day > 25 and day < 50:
		if roll <= 25:
			return false
		return true
	else:
		if roll <= 35:
			return false
		return true


func get_password_status() -> bool:
	var roll = randi_range(1, 100)
	match current_password_rule:
		"PAS1":
			if roll <= 15:
				return false
			return true
		"PAS2":
			if roll <= 18:
				return false
			return true
		"PAS3":
			if roll <= 25:
				return false
			return true
		"PAS4":
			if roll <= 30:
				return false
			return true
		"PAS5", "PAS6", "PAS7":
			if roll <= 35:
				return false
			return true
		_:
			return true


func load_password_regex_from_file() -> void:
	for entry in Globals.load_json(self.rules_filepath):
		var regex = RegEx.new()
		regex.compile(entry.regex)
		self.rules_dict[entry.id] = regex
	print(self.rules_dict)


func get_password(_is_correct: bool = true) -> String:
	var data: Array[String]
	if _is_correct:
		data = Globals.load_json("res://passwords_data/%s.json" % self.current_password_rule)
	else:
		data = Globals.load_json("res://password_data/PAS%d.json" % randi_range(0, self.current_password_rule.substr(3).to_int() - 1))
	var index: int = randi_range(0, data.size() - 1)
	return data[index]


func get_login_screen_data():
	var data = {}
	data['login'] = "kowal123"
	self.is_password_correct = self.get_password_status()
	data['is_password_correct'] = self.is_password_correct
	data['password'] = self.get_password(self.is_password_correct)
	
