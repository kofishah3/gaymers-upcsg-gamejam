extends Node2D
@export var pause_menu : Control

func _input(event):
	if event.is_action_pressed("pause"):
		pause_menu.toggle_pause()
