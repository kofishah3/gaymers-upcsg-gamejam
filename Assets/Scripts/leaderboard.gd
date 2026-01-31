extends Control

@export var save_manager : Node
@export var list_container : VBoxContainer
@export var entry_scene : PackedScene

func _ready():
	visible = false
	refresh()
		
func show_leaderboard():
	visible = true
	get_tree().paused = true
	refresh()

func hide_leaderboard():
	visible = false
	get_tree().paused = false

func refresh():
	# clear
	for child in list_container.get_children():
		child.queue_free()

	var leaderboard = SaveManager.get_leaderboard()

	for i in range(leaderboard.size()):
		var run = leaderboard[i]
		var entry = entry_scene.instantiate()

		var playername = run.get("name", "???")
		var score = int(run.get("score", 0))
		var time = float(run.get("time", 0))
		
		var time_str = "%.2f" % time
		entry.text = "#%02d  %-10s  |  %5d  |  %6ss" % [i + 1, playername, score, time_str]

		
		if i == 0:
			entry.modulate = Color.GOLD
		elif i == 1:
			entry.modulate = Color.SILVER
		elif i == 2:
			entry.modulate = Color("#cd7f32") # bronze

		list_container.add_child(entry)
