extends Node

# Reference to the ProgressBar node
@onready var boredom_bar: ProgressBar = $ProgressBar

# Configuration variables
@export var boredom_speed: float = 10.0 # How much boredom increases per second
var current_boredom: float = 0.0

func _ready() -> void:
	# Initialize the bar
	boredom_bar.value = current_boredom

func _process(delta: float) -> void:
	# Increase boredom over time, independent of frame rate
	if current_boredom < 100.0:
		current_boredom += boredom_speed * delta
		# Prevent the value from exceeding 100
		current_boredom = min(current_boredom, 100.0) 
		
		# Update the visual UI bar
		boredom_bar.value = current_boredom
		
		# Trigger an event if maximum boredom is reached
		if current_boredom >= 100.0:
			_on_maximum_boredom()

# Call this function from other scripts to lower boredom (e.g., giving a toy)
func reduce_boredom(amount: float) -> void:
	current_boredom -= amount
	current_boredom = max(current_boredom, 0.0) # Prevent negative values
	boredom_bar.value = current_boredom
	print("Boredom reduced! Current status: ", current_boredom)

func _on_maximum_boredom() -> void:
	print("The character is completely bored!")
	# Add game-over or behavioral changes here
