extends Node2D

func _on_start_button_down() -> void:
	print("PRESSED START")
	get_tree().change_scene_to_file("res://Assets/Scenes/Areas/NewGameScene.tscn")

func _on_leaderboards_button_down() -> void:
	print("Leaderboards pressed")
	# You can add leaderboard scene loading here later


func _on_exit_button_down() -> void:
	get_tree().quit()
