extends Node

const SAVE_PATH = "user://save_data.json"

var tile_counts := {}
var leaderboard := []

func _ready():
	load_data()

func save_data():
	var data = {
		"tile_counts": tile_counts,
		"leaderboard": leaderboard
	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()

func load_data():
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file yet")
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var text = file.get_as_text()
	file.close()

	var data = JSON.parse_string(text)

	if data == null:
		print("Save corrupted")
		return

	tile_counts = data.get("tile_counts", {})
	leaderboard = data.get("leaderboard", [])
