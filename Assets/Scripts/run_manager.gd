extends Node2D

@export var run_timer_label : Label
@export var tile_score_label: Label
@export var final_score_label: Label
@export var player : PlayerController
@export var tilemap : TileMapLayer
@export var debugtilemap : TileMapLayer
@export var leader_board: Control
@export var playerghost_scene: PackedScene

const BASE_TILE_SCORE = 10.0
const DECAY_PERPLAYER = 0.5
const BASE_LOWEST_POINT = 2.0
const TIME_REF := 30.0     
const MIN_TIME := 0.25     
const MIN_FACTOR := 0.5
const MAX_FACTOR := 2.0


var visited_tiles := {}
var global_tile_counts := {}

var run_time := 0.0
var running := true

# Debug tile info
const DEBUG_SOURCE_ID = 0
const DEBUG_ATLAS = Vector2i(0, 0)
const DEBUG_ALT = 0

# for recording our run data
var run_record := []
var record_timer := 0.0
const RECORD_INTERVAL := 0.05


func _ready():	
	# pull persistent tile counts
	global_tile_counts = SaveManager.tile_counts

	spawn_ghosts()	

func _process(delta):
	if not running:
		return

	run_time += delta
	run_timer_label.text = "%.2f" % run_time
	
	record_timer += delta
	if record_timer >= RECORD_INTERVAL:
		record_timer = 0.0
		record_snapshot()

	track_tile()

	var live_score = calculate_tile_score()
	tile_score_label.text = str(int(live_score))


# TILE TRACKING 

func tile_key(pos: Vector2i) -> String:
	return str(pos.x) + "," + str(pos.y)


func track_tile():
	var local_pos = tilemap.to_local(player.global_position)
	var tile_pos = tilemap.local_to_map(local_pos)
	var key = tile_key(tile_pos)

	if visited_tiles.has(key):
		return

	visited_tiles[key] = true

	# debug highlight
	debugtilemap.set_cell(tile_pos, DEBUG_SOURCE_ID, DEBUG_ATLAS, DEBUG_ALT)


# SCORING 
func calculate_tile_score() -> float:
	var score := 0.0

	for key in visited_tiles.keys():
		var visits = global_tile_counts.get(key, 0)

		var tile_value = BASE_TILE_SCORE - visits * DECAY_PERPLAYER
		tile_value = max(tile_value, BASE_LOWEST_POINT)
		score += tile_value

	return score


func update_global_counts():
	for key in visited_tiles.keys():
		global_tile_counts[key] = global_tile_counts.get(key, 0) + 1


# END RUN n STUFF

func end_run():
	running = false

	var tile_score = calculate_tile_score()
	var tf = time_factor(run_time)
	var final_score = tile_score * tf

	update_global_counts()
	
	SaveManager.tile_counts = global_tile_counts
	var run_data = {
		"name": GameManager.player_name,
		"time": run_time,
		"score": int(final_score),
		"tiles": visited_tiles.keys(),
		"record": run_record,
		"timestamp": Time.get_unix_time_from_system()
	}

	SaveManager.add_run(run_data)
	
	final_score_label.text = str(int(final_score))
	
	if leader_board:
		leader_board.display_results()
	else:
		print("Warning: leader_board is not assigned in RunManager")

func record_snapshot():
	run_record.append({
		"t": run_time,
		"x": player.global_position.x,
		"y": player.global_position.y
	})
	

var ghost_colors = [
	Color(0.4, 0.8, 1.0, 0.7),
	Color(0.806, 0.56, 0.0, 0.7), 
	Color(0.4, 1.0, 0.6, 0.7)  
]

func spawn_ghosts():
	var recent_runs = SaveManager.get_recent_runs(3)
	
	for i in range(recent_runs.size()):
		var ghost = playerghost_scene.instantiate()
		add_child(ghost)
		
		print(ghost)
		ghost.start(
			recent_runs[i]["record"],
			ghost_colors[i % ghost_colors.size()]
		)
		
func time_factor(t: float) -> float:
	t = max(t, MIN_TIME)
	var f = TIME_REF / t
	return clamp(f, MIN_FACTOR, MAX_FACTOR)
