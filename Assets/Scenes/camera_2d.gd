extends Camera2D

var shake_amount := 0.0
var shake_decay := 5.0  # How fast shake diminishes
var default_offset := Vector2(0,0)

func _ready():
	default_offset = offset

func _process(delta):
	# Apply shake
	if shake_amount > 0:
		shake_amount = max(shake_amount - shake_decay * delta, 0)
		offset = default_offset + Vector2(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		)
	else:
		offset = default_offset

func shake(intensity: float):
	shake_amount = intensity
