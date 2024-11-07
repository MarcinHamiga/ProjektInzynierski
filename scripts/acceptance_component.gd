extends MarginContainer

var match_info: RichTextLabel
var accept_button: Button
var decline_button: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.match_info = $MainContainer/MatchInfoContainer/MatchInfoMargin/MatchInfoSpacing/MatchInfo
	self.accept_button = $MainContainer/ButtonContainer/ButtonMargin/ButtonSpacing/AcceptButton
	self.decline_button = $MainContainer/ButtonContainer/ButtonMargin/ButtonSpacing/DeclineButton
