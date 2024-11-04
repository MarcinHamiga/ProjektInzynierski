extends Control

signal coming_next

var _login: Label
var _password: Label
var _tfa: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self._login = $UserData/Login
	self._password = $UserData/Password
	self._tfa = $UserData/TFA

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_login() -> String:
	return self._login.text

func set_login(login: String) -> String:
	self._login.text = login
	return self._login.text

func get_password() -> String:
	return self._password.text

func set_password(password: String) -> String:
	self._password.text = password
	return self._password.text

func get_tfa() -> String:
	return self._tfa.text

func set_tfa(tfa: String) -> String:
	self._tfa.text = tfa
	return self._tfa.text
