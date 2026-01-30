extends Node2D

const BASE_TILE_SCORE = 10.0
const DECAY_PERPLAYER = 0.5
const BASE_LOWEST_POINT = 2.0

@export var run_timer_label : Label
@export var tile_score_label: Label
@export var final_score_label: Label
@export var player : PlayerController
@export var tilemap : TileMapLayer
@export var debugtilemap : TileMapLayer
@export var save_manager : Node   # SaveManager

var visited_tiles := {}
var global_tile_counts := {}

var run_time := 0.0
var running := true

# Debug tile info
const DEBUG_SOURCE_ID = 0
const DEBUG_ATLAS = Vector2i(0, 0)
const DEBUG_ALT = 0

func _ready():
	# pull persistent tile counts
	global_tile_counts = save_manager.tile_counts

func _process(delta):
	if not running:
		return

	run_time += delta
	run_timer_label.text = "%.2f" % run_time

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
	print("NEW NEW NEW NEW ++++++++++++++++++++++++++++++++++")
	var score := 0.0

	for key in visited_tiles.keys():
		var visits = global_tile_counts.get(key, 0)

		var tile_value = BASE_TILE_SCORE - visits * DECAY_PERPLAYER
		tile_value = max(tile_value, BASE_LOWEST_POINT)
		print("key:", key, " value:", tile_value)
		score += tile_value

	return score


func update_global_counts():
	for key in visited_tiles.keys():
		global_tile_counts[key] = global_tile_counts.get(key, 0) + 1


# END RUN n STUFF

func end_run():
	running = false

	var tile_score = calculate_tile_score()
	var final_score = tile_score

	update_global_counts()

	# persist results
	save_manager.tile_counts = global_tile_counts
	save_manager.leaderboard.append(int(final_score))
	save_manager.save_data()

	final_score_label.text = str(int(final_score))

	print("Run time:", run_time)
	print("Tile score:", tile_score)
	print("FINAL:", final_score)
