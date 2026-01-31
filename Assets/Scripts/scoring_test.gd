extends Node2D

@onready var leaderboard_ui = %Leaderboard
# We reference the node that has your PauseMenu script attached
@onready var pause_menu = %PauseMenu 
@onready var player = %Player 

# Helper to reference the Main Menu script
const MainMenuScript = preload("res://Assets/Scenes/MainMenu/main_menu.gd")

var is_game_over = false

func _ready():
	# Ensure UI is hidden at start
	if pause_menu: pause_menu.hide()

func _input(event):
	if event.is_action_pressed("ui_cancel") and not is_game_over:
		if pause_menu:
			pause_menu.toggle_pause()
			get_tree().root.set_input_as_handled()

# --- CALL THIS WHEN FINISH LINE IS CROSSED ---
func game_over(final_score: int, time_taken_str: String):
	is_game_over = true
	print("Level Complete!")
	
	# Pause the game physics/logic
	get_tree().paused = true 
	
	# Pass data to leaderboard
	var current_name = MainMenuScript.player_name
	if leaderboard_ui:
		leaderboard_ui.visible = true
		leaderboard_ui.display_results(current_name, time_taken_str, final_score)
	
	# Ensure cursor is visible
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
