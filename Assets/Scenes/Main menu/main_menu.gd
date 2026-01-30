extends Node2D

func _ready():
	# Connect button signals to their handler functions
	$Control/VBoxContainer/Start.pressed.connect(_on_start_pressed)
	$Control/VBoxContainer/Leaderboards.pressed.connect(_on_leaderboards_pressed)
	$Control/VBoxContainer/Exit.pressed.connect(_on_exit_pressed)

func _on_start_pressed():
	# Change to your main game scene path
	get_tree().change_scene_to_file("res://Assets/Scenes/Areas/NewGameScene.tscn")

func _on_leaderboards_pressed():
	# Placeholder for leaderboards
	print("Leaderboards pressed")
	# You can add leaderboard scene loading here later

func _on_exit_pressed():
	# Exit the game
	get_tree().quit()
