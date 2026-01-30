extends Node2D
@export var pause_menu : Control

func _input(event):
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			pause_menu.close()
		else:
			pause_menu.open()
