extends Node2D

@onready var name_input_dialog = $CanvasLayer/NameInputDialog
@onready var name_input = $CanvasLayer/NameInputDialog/ChatFrame/InputContainer/NameInput
@onready var start_button = $CanvasLayer/Control/StartButton
@onready var leaderboards_button = $CanvasLayer/Control/LeaderboardsButton
@onready var exit_button = $CanvasLayer/Control/ExitButton

@export var leaderboards_scene : Control

var player_name

func _ready():
	name_input_dialog.hide()
	
	start_button.pressed.connect(_on_start_pressed)
	leaderboards_button.pressed.connect(_on_leaderboards_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _input(event):
	if event.is_action_pressed("ui_cancel") or (event is InputEventKey and event.keycode == KEY_ESCAPE):
		if name_input_dialog.visible:
			name_input_dialog.hide()
			name_input.release_focus()

# --- Button Handlers ---

func _on_start_pressed():
	name_input_dialog.show()
	name_input.grab_focus()

func _on_leaderboards_pressed():
	leaderboards_scene.display_top_10()

func _on_exit_pressed():
	get_tree().quit()

# --- Input Dialog Signals ---

func _on_name_input_text_changed(new_text: String):
	if new_text.length() > 20:
		name_input.text = new_text.left(20)
		name_input.caret_column = 20

func _on_name_input_confirmed(new_text: String):
	if new_text.strip_edges() != "":
		# --- NEW: Save the name here! ---
		player_name = new_text		
		GameManager.update_name(player_name)
			
		# User requested link to NewGameScene instead of scoring_test
		var game_path = "res://Assets/Scenes/Areas/NewGameScene.tscn"
		_change_scene_safely(game_path)
	else:
		print("Please enter a name!")
	
# --- Helper Function ---

func _change_scene_safely(path: String):
	if ResourceLoader.exists(path):
		var error = get_tree().change_scene_to_file(path)
		if error != OK:
			print("Error: Scene change failed with code: ", error)
	else:
		printerr("CRITICAL ERROR: Scene file not found at " + path)
