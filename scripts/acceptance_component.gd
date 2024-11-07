extends MarginContainer

var match_info: RichTextLabel
var accept_button: Button
var decline_button: Button

signal accept_pressed
signal decline_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.match_info = $MainContainer/MatchInfoContainer/MatchInfoMargin/MatchInfoSpacing/MatchInfo
	self.accept_button = $MainContainer/ButtonContainer/ButtonMargin/ButtonSpacing/AcceptButton
	self.decline_button = $MainContainer/ButtonContainer/ButtonMargin/ButtonSpacing/DeclineButton
	self.accept_button.disabled = true
	self.decline_button.disabled = true

func _on_accept_button_pressed():
	accept_pressed.emit()

func _on_decline_button_pressed():
	decline_pressed.emit()

func disable_buttons():
	self.accept_button.disabled = true
	self.decline_button.disabled = true

func enable_buttons():
	self.accept_button.disabled = false
	self.decline_button.disabled = false
