extends Node2D

var record := []
var index := 0
var elapsed := 0.0
var playing := false

func start(record_data, ghost_color := Color(1, 1, 1, 0.7)):
	record = record_data
	index = 0
	elapsed = 0.0
	playing = true
	
	modulate = Color(1,1,1,1)
	$Sprite2D.modulate = ghost_color

	if record.size() > 0:
		global_position = Vector2(record[0]["x"], record[0]["y"])


func _process(delta):
	if not playing:
		var c = $Sprite2D.modulate
		c.a = lerp(c.a, 0.0, delta * 3.0)
		$Sprite2D.modulate = c
		if c.a < 0.05:
			queue_free()
		return


	# Need at least 2 points to interpolate
	if record.size() < 2:
		playing = false
		return

	elapsed += delta

	# If we've reached or passed the end time, finish safely
	if index >= record.size() - 1:
		playing = false
		return

	# Advance index while next snapshot is in the past
	while index < record.size() - 2 and record[index + 1]["t"] <= elapsed:
		index += 1

	var current = record[index]
	var next = record[index + 1]

	var t0 = current["t"]
	var t1 = next["t"]

	if t1 <= t0:
		return

	var alpha = (elapsed - t0) / (t1 - t0)
	alpha = clamp(alpha, 0.0, 1.0)

	var pos0 = Vector2(current["x"], current["y"])
	var pos1 = Vector2(next["x"], next["y"])
	
	global_position = pos0.lerp(pos1, alpha)
