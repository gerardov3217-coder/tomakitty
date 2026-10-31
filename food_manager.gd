extends Area2D

@export var food_data: FoodData

func _ready() -> void:
	# Connect the body_entered signal to detect the player
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		consume_food(body)

func consume_food(player: Node2D) -> void:
	if food_data:
		print("Ate " + food_data.food_name + " for " + str(food_data.heal_amount) + " health!")
		# Add your player healing logic here, e.g., player.heal(food_data.heal_amount)
	
	# Remove the food from the world after eating
	queue_free()
