extends Control

func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	self.hide()

func toggle_pause():
	var tree = get_tree()
	tree.paused = not tree.paused
	
	if tree.paused:
		self.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		self.hide()

func _on_resume_button_down():
	toggle_pause()

func _on_retry_button_down():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_button_down():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Assets/Scenes/MainMenu/main_menu_scene.tscn")
