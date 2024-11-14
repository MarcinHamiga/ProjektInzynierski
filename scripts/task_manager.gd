extends Node

signal ready_login_screen

@export var task_time_left_timer: Timer
@export var next_task_timer: Timer
@export var password_rules_filepath: String = "res://rules/password_rules.json"
@export var current_password_rule: String

var current_task: Globals.Tasks
var is_password_correct: bool
var is_tfa_correct: bool
var rules_dict: Dictionary
var current_tfa_rule: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	self.load_password_regex_from_file()
	self.get_login_screen_data()


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
	for entry in Globals.load_json(self.password_rules_filepath):
		var regex: RegEx = RegEx.new()
		regex.compile(entry.regex)
		self.rules_dict[entry.id] = regex
	print(self.rules_dict)


func get_password(_is_correct: bool = true) -> String:
	var data: Array
	if _is_correct:
		var filePath: String = "res://passwords_data/" + self.current_password_rule + ".json"
		data = Globals.load_json(filePath)
	else:
		var fileNumber = self.current_password_rule.substr(3).to_int()
		var filePath: String = "res://passwords_data/PAS" + str(randi_range(0, fileNumber - 1)) + ".json"
		data = Globals.load_json(filePath)
	var index: int = randi_range(0, data.size() - 1)
	return self.shuffle_password(data[index])


func shuffle_password(password: String) -> String:
	var password_array: Array = password.split("")
	password_array.shuffle()
	var output = ""
	for _char in password_array:
		output += _char
	return output


func verify_password(password: String) -> bool:
	if current_password_rule in rules_dict:
		var match = rules_dict[current_password_rule].search(password)
		return match != null
	else:
		print("Rule not found for:", current_password_rule)
		return false


func get_login_screen_data() -> void:
	var data = {}
	data['login'] = "kowal123"
	self.is_password_correct = self.get_password_status()
	var password = self.get_password(self.is_password_correct)

	if not self.is_password_correct or self.verify_password(password):
		data['is_password_correct'] = self.is_password_correct
	else:
		self.is_password_correct = false
		data['is_password_correct'] = false

	data['password'] = password

	print(data)
	ready_login_screen.emit(data)

	
