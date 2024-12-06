extends VBoxContainer

@export var label_text: String = "text"
@export var start_value: float = 50.0
@export var range_min: float = 1.0
@export var range_max: float = 100.0
@export var step: float = 1.0

var slider_label: Label
var slider: HSlider

signal value_changed

func _ready():
	self.slider_label = $SliderLabel
	self.slider_label.text = label_text
	self.slider = $Slider
	self.slider.min_value = range_min
	self.slider.max_value = range_max
	self.slider.step = step
	self.slider.value = start_value


func _on_slider_value_changed(value: float) -> void:
	value_changed.emit(value)
