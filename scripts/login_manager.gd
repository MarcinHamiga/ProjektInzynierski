extends Node

@export var password_rules_filepath: String = "res://rules/password_rules.json"
@export var current_password_rule: String = "PAS1"
@export var current_tfa_rule: String = "TFA1"

var rules_dict: Dictionary
func _ready() -> void:
	randomize()
	self._load_password_regex_from_file()


func _get_tfa_status() -> bool:
	var roll = randi_range(1, 100)
	match self.current_tfa_rule:
		"TFA1":
			return true
		"TFA2":
			if roll <= 20:
				return false
			return true
		"TFA3":
			if roll <= 25:
				return false
			return true
		"TFA4":
			if roll <= 33:
				return false
			return true
		"TFA5":
			if roll <= 40:
				return false
			return true
		_:
			return true


func _get_password_status() -> bool:
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


func _load_password_regex_from_file() -> void:
	for entry in Globals.load_json(self.password_rules_filepath):
		var regex: RegEx = RegEx.new()
		regex.compile(entry.regex)
		self.rules_dict[entry.id] = regex
	print(self.rules_dict)


func _get_password(_is_correct: bool = true) -> String:
	var data: Array
	if _is_correct:
		var filePath: String = "res://passwords_data/" + self.current_password_rule + ".json"
		data = Globals.load_json(filePath)
	else:
		var fileNumber = self.current_password_rule.substr(3).to_int()
		var filePath: String = "res://passwords_data/PAS" + str(randi_range(0, fileNumber - 1)) + ".json"
		data = Globals.load_json(filePath)
	var index: int = randi_range(0, data.size() - 1)
	return self._shuffle_password(data[index])


func _shuffle_password(password: String) -> String:
	var password_array: Array = password.split("")
	password_array.shuffle()
	var output = ""
	for _char in password_array:
		output += _char
	return output


func _verify_password(password: String) -> bool:
	if current_password_rule in rules_dict:
		var match = rules_dict[current_password_rule].search(password)
		return match != null
	else:
		print("Rule not found for:", current_password_rule)
		return false


func _get_tfa(is_correct: bool) -> String:
	var filePath: String = "res://passwords_data/TFA.json"
	var data: Array = Globals.load_json(filePath)
	var current_rule_index: int = self.current_tfa_rule.substr(3).to_int() - 1
	print("Current tfa rule: %s\nCurrent tfa index: %d" % [self.current_tfa_rule, current_rule_index])
	if is_correct:
		return data[current_rule_index]
	
	var wrong_index = randi_range(0, current_rule_index - 1)
	if wrong_index < 0:
		wrong_index = 0
		
	return data[wrong_index]


func get_login_screen_data(target_signal: Signal) -> Dictionary:
	var data = {}
	data['login'] = "kowal123"
	data['is_password_correct'] = self._get_password_status()
	data['password'] = self._get_password(data['is_password_correct'])
	if not self._verify_password(data['password']):
		data['is_password_correct'] = false
	data['is_tfa_correct'] = self._get_tfa_status()
	data['tfa'] = self._get_tfa(data['is_tfa_correct'])

	print(data)
	target_signal.emit(data)
	return data


func set_tfa_rule(rule: String) -> void:
	self.current_tfa_rule = rule


func set_password_rule(rule: String) -> void:
	self.current_password_rule = rule


func get_password_rule() -> String:
	return self.current_password_rule


func get_tfa_rule() -> String:
	return self.current_tfa_rule
