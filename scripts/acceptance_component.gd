extends MarginContainer

@export var match_info_disappearance_time: float

var match_info: RichTextLabel
var accept_button: Button
var decline_button: Button
var match_info_timer: Timer
var strikes: RichTextLabel
var time_left_bar: ProgressBar

signal accept_pressed
signal decline_pressed
signal get_time_left

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.match_info = $MainContainer/MatchInfoContainer/MatchInfoMargin/MatchInfoSpacing/MatchInfo
	self.accept_button = $MainContainer/ButtonContainer/ButtonMargin/ButtonSpacing/AcceptButton
	self.decline_button = $MainContainer/ButtonContainer/ButtonMargin/ButtonSpacing/DeclineButton
	self.match_info_timer = $MatchInfoDisappearTimer
	self.strikes = $MainContainer/MatchInfoContainer/MatchInfoMargin/MatchInfoSpacing/Strikes
	self.time_left_bar = $MainContainer/MatchInfoContainer/MatchInfoMargin/MatchInfoSpacing/TimeLeftBar
	self.time_left_bar.min_value = 0
	self.match_info_timer.wait_time = self.match_info_disappearance_time
	self.match_info_timer.autostart = false
	self.match_info_timer.one_shot = true
	self.accept_button.disabled = true
	self.decline_button.disabled = true


func _process(delta: float) -> void:
	get_time_left.emit(self.update_time_left_bar)


func update_time_left_bar(value: float, max_value: float, reversed: bool = false) -> void:
	value = Globals.round_to_decimals(value, 2)
	if value == max_value and not reversed:
		value = 0
	if reversed:
		value = max_value - value
	self.time_left_bar.max_value = max_value
	self.time_left_bar.value = value


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
	
	
func reset():
	self.strikes.text = "Błędy: 0"
	self.match_info.text = ""
	self.disable_buttons()
