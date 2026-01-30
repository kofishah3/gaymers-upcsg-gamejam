extends Control

func _ready():
	visible = false

func open():
	visible = true
	get_tree().paused = true

func close():
	visible = false
	get_tree().paused = false

func _on_resume_button_down() -> void:
	close()

func _on_retry_button_down() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_button_down() -> void:
	close()
	get_tree().change_scene_to_file("res://Assets/Scenes/MainMenu/main_menu_scene.tscn")
