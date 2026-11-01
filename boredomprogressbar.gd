extends ProgressBar

@export var boredom_increase_rate: float = 5.0 # Units per second
@export var boredom_decrease_on_action: float = 20.0 # Drop when player acts

func _ready() -> void:
	value = min_value

func _process(delta: float) -> void:
	# Gradually increase boredom over time
	value += boredom_increase_rate * delta
	
	# Example check: Pressing 'ui_accept' (Space/Enter) or moving resets/lowers boredom
	if Input.is_action_just_pressed("ui_accept"):
		reduce_boredom(boredom_decrease_on_action)

func reduce_boredom(amount: float) -> void:
	value = max(value - amount, min_value)
