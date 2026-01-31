extends Node

const SAVE_PATH = "user://save_data.json"

var tile_counts := {}
var leaderboard := []
var runs := [] # store 20 runs

const MAX_RUNS := 20
const LEADERBOARD_SIZE := 10
const BASE_TILE_SCORE = 10.0
const DECAY_PERPLAYER = 0.5
const BASE_LOWEST_POINT = 2.0

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
	var score := 0.0
	
	for key in run["tiles"]:
		var visits = tile_counts.get(key, 0)
		var value = BASE_TILE_SCORE - visits * DECAY_PERPLAYER
		value = max(value, BASE_LOWEST_POINT)
		score += value

	return int(score)


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


# THIS JUST FOR ME DEBUGGING ----------------------
#func debug_print_run(run):
	#print("================ RUN SAVED ================")
	#print("Name: ", run.get("name", ""))
	#print("Time: ", "%.2f" % float(run.get("time", 0.0)))
	#print("Score: ", int(run.get("score", 0)))
	#print("Unique tiles: ", (run.get("tiles", []) as Array).size())
	#print("Snapshots: ", (run.get("record", []) as Array).size())
	#print("TileCounts entries: ", tile_counts.size())
	#print("==========================================")
#
#func debug_print_leaderboard():
	#print("\n================ LEADERBOARD (TOP ", LEADERBOARD_SIZE, ") ================")
	#var lb = get_leaderboard()
	#if lb.is_empty():
		#print("No runs yet.")
		#print("==========================================================================")
		#return
#
	#for i in range(lb.size()):
		#var run = lb[i]
		#var nickname = run.get("name", "???")
		#var score = int(run.get("score", 0))
		#var time = float(run.get("time", 0.0))
		#print("#", i + 1, " | ", nickname, " | score=", score, " | time=", "%.2f" % time,
			#" | tiles=", (run.get("tiles", []) as Array).size())
	#print("==========================================================================")
#
#func debug_print_ghost_candidates():
	#print("\n================ GHOST CANDIDATES (RECENT 3) ================")
	#var ghosts = get_recent_runs()
	#if ghosts.is_empty():
		#print("No ghosts yet.")
		#print("==========================================================")
		#return
#
	#for i in range(ghosts.size()):
		#var run = ghosts[i]
		#print("#", i + 1, " | ", run.get("name", "???"),
			#" | score=", int(run.get("score", 0)),
			#" | snapshots=", (run.get("record", []) as Array).size())
	#print("==========================================================")
