extends Control
class_name ResourceBar
# Reference your UI nodes at the top of your script
@onready var label: Label = %Label
@onready var progress_bar: ProgressBar = %ProgressBar

@export var title := "HP"

var current_value: float = 0

func set_title(text: String) -> void:
	label.text = text

func set_value(value: float) -> void:
	current_value = value
	progress_bar.value = value

func set_max_value(value: float) -> void:
	progress_bar.max_value = value
