extends MarginContainer

@export var match_info_disappearance_time: float

var match_info: RichTextLabel
var accept_button: Button
var decline_button: Button
var match_info_timer: Timer
var strikes: RichTextLabel

signal accept_pressed
signal decline_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.match_info = $MainContainer/MatchInfoContainer/MatchInfoMargin/MatchInfoSpacing/MatchInfo
	self.accept_button = $MainContainer/ButtonContainer/ButtonMargin/ButtonSpacing/AcceptButton
	self.decline_button = $MainContainer/ButtonContainer/ButtonMargin/ButtonSpacing/DeclineButton
	self.match_info_timer = $MatchInfoDisappearTimer
	self.strikes = $MainContainer/MatchInfoContainer/MatchInfoMargin/MatchInfoSpacing/Strikes
	self.match_info_timer.wait_time = self.match_info_disappearance_time
	self.match_info_timer.autostart = false
	self.match_info_timer.one_shot = true
	self.accept_button.disabled = true
	self.decline_button.disabled = true

func _on_accept_button_pressed() -> void:
	accept_pressed.emit()

func _on_decline_button_pressed() -> void:
	decline_pressed.emit()

func disable_buttons() -> void:
	self.accept_button.disabled = true
	self.decline_button.disabled = true

func enable_buttons() -> void:
	self.accept_button.disabled = false
	self.decline_button.disabled = false

func write_to_match_info(text: String) -> void:
	self.match_info.text = text
	self.match_info_timer.start()
	

func write_to_strikes(amount: int) -> void:
	self.strikes.text = "Błędy: %d" % [amount]

func _on_match_info_disappear_timer_timeout() -> void:
	self.match_info.text = ""
