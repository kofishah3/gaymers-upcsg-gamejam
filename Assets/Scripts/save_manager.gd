extends Node

const SAVE_PATH = "user://save_data.json"

var tile_counts := {}
var leaderboard := []
var current_player_name := ""
var runs := [] # store 20 runs

const MAX_RUNS := 20
const LEADERBOARD_SIZE := 10
const BASE_TILE_SCORE = 10.0
const DECAY_PERPLAYER = 0.5
const BASE_LOWEST_POINT = 2.0

const TIME_REF := 30.0      
const MIN_TIME := 0.25      
const MIN_FACTOR := 0.5
const MAX_FACTOR := 2.0


func _ready():
	load_data()

func save_data():
	var data = {
		"tile_counts": tile_counts,
		"runs": runs
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
	runs = data.get("runs", [])


# score recalculation
func score_for_run(run):
	var tile_sum := 0.0
	for key in run["tiles"]:
		var visits = tile_counts.get(key, 0)
		var value = BASE_TILE_SCORE - visits * DECAY_PERPLAYER
		value = max(value, BASE_LOWEST_POINT)
		tile_sum += value

	var t = float(run.get("time", 9999.0))
	var tf = time_factor(t)
	return int(tile_sum * tf)


func add_run(run_data):
	runs.append(run_data)

	for run in runs:
		run["score"] = score_for_run(run)

	runs.sort_custom(func(a, b):
		return a["score"] > b["score"]
	)

	if runs.size() > MAX_RUNS:
		runs = runs.slice(0, MAX_RUNS)

	save_data()
	
	#debug_print_run(run_data)
	#debug_print_leaderboard()
	#debug_print_ghost_candidates()

	
func get_leaderboard():
	return runs.slice(0, min(LEADERBOARD_SIZE, runs.size()))

func get_recent_runs(count := 3):
	if runs.is_empty():
		return []

	var copy = runs.duplicate()
	copy.sort_custom(func(a, b):
		return a["timestamp"] > b["timestamp"]
	)

	return copy.slice(0, min(count, copy.size()))

func time_factor(t: float) -> float:
	t = max(t, MIN_TIME)
	var f = TIME_REF / t
	return clamp(f, MIN_FACTOR, MAX_FACTOR)
