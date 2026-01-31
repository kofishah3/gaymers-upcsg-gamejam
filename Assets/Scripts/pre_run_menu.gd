extends Control

@export var save_manager : Node

func _ready():
	visible = true
	get_tree().paused = true

func open():
	visible = true
	get_tree().paused = true

func close():
	visible = false
	get_tree().paused = false

var player_name

func _on_line_edit_text_changed(new_text: String) -> void:
	player_name = new_text
	
func _on_start_button_down() -> void:
	if not player_name:
		player_name = "Guest"

	save_manager.current_player_name = player_name
	close()

func _on_main_menu_button_down() -> void:
	close()
	get_tree().change_scene_to_file("res://Assets/Scenes/MainMenu/main_menu_scene.tscn")
