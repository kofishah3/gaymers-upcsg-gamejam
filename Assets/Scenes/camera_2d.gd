extends Camera2D

@export var decay := 10.0

var shake_strength := 0.0

func _process(delta):
	if shake_strength > 0:
		shake_strength = max(shake_strength - decay * delta, 0)
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
	else:
		offset = Vector2.ZERO

func shake(amount: float):
	shake_strength = max(shake_strength, amount)
