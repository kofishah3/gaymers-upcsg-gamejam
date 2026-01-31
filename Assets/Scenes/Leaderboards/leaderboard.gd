extends Control

# Using unique names (%) to find nodes regardless of scene structure
@onready var score_list = %ScoreList
@onready var loading_label = %LoadingLabel
@onready var title_label = $BoardFrame/VBoxContainer/TopBar/TitleLabel

# Empty array - No dummy players anymore
var high_scores = []

func _ready():
	# Check if opened directly from Main Menu or embedded in Game
	if get_parent() == get_tree().root:
		display_top_10()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_back_button_pressed():
	var menu_path = "res://Assets/Scenes/MainMenu/main_menu_scene.tscn"
	_change_scene_safely(menu_path)

# --- MODE 1: Main Menu View ---
func display_top_10():
	self.show()
	if title_label: title_label.text = "TOP 10 PLAYERS"
	_clear_list()
	
	if high_scores.is_empty():
		if loading_label: 
			loading_label.show()
			loading_label.text = "NO RECORDS FOUND"
	else:
		if loading_label: loading_label.hide()
		for i in range(high_scores.size()):
			var data = high_scores[i]
			_add_entry_row(i + 1, data.name, data.time, str(data.score))

# --- MODE 2: Game Over View ---
func display_results(player_name: String, time_str: String, score_val: int):
	self.show()
	self.move_to_front()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if title_label: title_label.text = "MISSION COMPLETE"
	_clear_list()
	
	# 1. Display top 5 scores from high_scores
	for i in range(min(5, high_scores.size())):
		var data = high_scores[i]
		_add_entry_row(i + 1, data.name, data.time, str(data.score))
		
	# 2. Add separator only if we had previous scores
	if not high_scores.is_empty():
		_add_separator()
	
	# 3. Add Current Player
	# We use Rank "1" because they are the only one on the list right now
	var row = _add_entry_row(1, player_name, time_str, str(score_val))
	
	# Highlight the player row (Gold/Yellow)
	row.modulate = Color(1, 0.8, 0.2) 
	
	# Set the rank label to "YOU" to make it look nicer
	var rank_label = row.get_child(0) as Label
	if rank_label: rank_label.text = "YOU"

# --- HELPERS ---

func _clear_list():
	if loading_label: loading_label.hide()
	for child in score_list.get_children():
		if child != loading_label:
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
	var lbl_time = _create_label(time, 60, HORIZONTAL_ALIGNMENT_RIGHT)
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

func show_leaderboard():
	self.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
