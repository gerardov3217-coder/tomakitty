extends Node

# Global signals for decoupling systems
signal score_changed(new_score: int)
signal game_state_changed(new_state: GameState)
signal player_health_changed(current: int, max_health: int)

# Enums for explicit state tracking
enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

# Explicitly typed global variables
var current_state: GameState = GameState.MENU : set = _set_game_state
var current_score: int = 0
var player_max_health: int = 100
var player_current_health: int = 100

func _ready() -> void:
	# Initialize system setup here
	process_mode = Node.PROCESS_MODE_ALWAYS # Keeps manager running when tree is paused
	print_raw("System initialization complete.\n")

# Setter function ensuring state logic updates smoothly
func _set_game_state(new_state: GameState) -> void:
	if current_state == new_state:
		return
	
	current_state = new_state
	game_state_changed.emit(current_state)
	
	match current_state:
		GameState.MENU:
			get_tree().paused = false
		GameState.PLAYING:
			get_tree().paused = false
		GameState.PAUSED:
			get_tree().paused = true
		GameState.GAME_OVER:
			get_tree().paused = true

# Core API functions
func add_score(amount: int) -> void:
	current_score += amount
	score_changed.emit(current_score)

func damage_player(amount: int) -> void:
	player_current_health = clampi(player_current_health - amount, 0, player_max_health)
	player_health_changed.emit(player_current_health, player_max_health)
	
	if player_current_health <= 0:
		_set_game_state(GameState.GAME_OVER)

func reset_game() -> void:
	current_score = 0
	player_current_health = player_max_health
	_set_game_state(GameState.PLAYING)

## Changes scenes dynamically using thread safety
func switch_scene(target_scene_path: String) -> void:
	# Defer call to guarantee current scene thread finishes first
	call_deferred("_deferred_switch_scene", target_scene_path)

func _deferred_switch_scene(path: String) -> void:
	var root = get_tree().root
	# Assume the active scene is the last child of root
	var current_scene = root.get_child(root.get_child_count() - 1)
	current_scene.free()
	
	var new_scene_resource = load(path)
	if new_scene_resource:
		var new_scene = new_scene_resource.instantiate()
		root.add_child(new_scene)
		get_tree().current_scene = new_scene
