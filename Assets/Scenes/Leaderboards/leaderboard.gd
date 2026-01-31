extends Control

@onready var score_list = %ScoreList
@onready var title_label = $BoardFrame/VBoxContainer/TopBar/TitleLabel

func _ready():
	# If this is opened directly as a scene, show the top 10
	hide()

func _on_back_button_pressed():
	var menu_path = "res://Assets/Scenes/MainMenu/main_menu_scene.tscn"
	_change_scene_safely(menu_path)

# --- MODE 1: Main Menu View ---
func display_top_10():
	show()
	if title_label:
		title_label.text = "TOP 10 PLAYERS"

	_clear_list()

	# Pull from backend
	var leaderboard: Array = SaveManager.get_leaderboard()

	for i in range(leaderboard.size()):
		var run: Dictionary = leaderboard[i]
		var playername := str(run.get("name", "???"))
		var score := int(run.get("score", 0))
		var time := float(run.get("time", 0.0))
		var time_str := "%.2f" % time

		_add_entry_row(i + 1, playername, time_str, str(score))

# --- MODE 2: Game Over View (optional) ---
func display_results():
	show()
	move_to_front()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if title_label:
		title_label.text = "MISSION COMPLETE"

	_clear_list()

	var leaderboard: Array = SaveManager.get_leaderboard()

	# show top 10
	for i in range(min(10, leaderboard.size())):
		var run: Dictionary = leaderboard[i]
		var playername := str(run.get("name", "???"))
		var score := int(run.get("score", 0))
		var t := float(run.get("time", 0.0))
		var t_str := "%.2f" % t
		_add_entry_row(i + 1, playername, t_str, str(score))

	if not leaderboard.is_empty():
		_add_separator()

# --- HELPERS ---

func _clear_list():
	for child in score_list.get_children():
		child.queue_free()

func _add_separator():
	var sep = HSeparator.new()
	sep.modulate = Color(1, 1, 1, 0.5)
	score_list.add_child(sep)

func _add_entry_row(rank: int, username: String, time: String, score: String) -> HBoxContainer:
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 5)

	var lbl_rank = _create_label(str(rank), 30, HORIZONTAL_ALIGNMENT_CENTER)
	var lbl_name = _create_label(username, 0, HORIZONTAL_ALIGNMENT_LEFT, true)
	var lbl_time = _create_label(time + "s", 60, HORIZONTAL_ALIGNMENT_RIGHT)
	var lbl_score = _create_label(score, 60, HORIZONTAL_ALIGNMENT_RIGHT)

	hbox.add_child(lbl_rank)
	hbox.add_child(lbl_name)
	hbox.add_child(lbl_time)
	hbox.add_child(lbl_score)

	score_list.add_child(hbox)
	return hbox

func _create_label(txt: String, min_width: int, align: int, expand: bool = false) -> Label:
	var lbl = Label.new()
	lbl.text = txt
	lbl.custom_minimum_size.x = min_width
	lbl.horizontal_alignment = align
	if expand:
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl.add_theme_font_size_override("font_size", 12)
	return lbl

func _change_scene_safely(path: String):
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)
	else:
		printerr("Error: Scene file not found at " + path)
