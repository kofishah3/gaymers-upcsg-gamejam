extends Node2D

func _ready() -> void:
	# Connect Start Button signals
	var start_button = $CanvasLayer/Control/StartButton
	start_button.button_down.connect(_on_start_button_down)
	
	# Connect Leaderboards Button signals
	var leaderboards_button = $CanvasLayer/Control/LeaderboardsButton
	leaderboards_button.button_down.connect(_on_leaderboards_button_down)
	
	# Connect Exit Button signals
	var exit_button = $CanvasLayer/Control/ExitButton
	exit_button.button_down.connect(_on_exit_button_down)

func _on_start_button_down() -> void:
	print("PRESSED START")
	get_tree().change_scene_to_file("res://Assets/Scenes/Areas/scoring_test.tscn")

func _on_leaderboards_button_down() -> void:
	print("Leaderboards pressed")
	# You can add leaderboard scene loading here later


func _on_exit_button_down() -> void:
	get_tree().quit()
