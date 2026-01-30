extends CharacterBody2D

@export var player: Node2D
@export var follow_offset := Vector2(-20, -25)
@export var follow_speed := 5.0

@export var max_tilt_deg := 20.0      # max tilt angle
@export var tilt_smooth := 10.0       # rotation smoothing

var last_position: Vector2

func _ready():
	last_position = global_position

func _physics_process(delta):
	if not player:
		return

	var target_pos := player.global_position + follow_offset
	global_position = global_position.lerp(target_pos, follow_speed * delta)

	# TILT LOGIC
	velocity = (global_position - last_position) / delta
	last_position = global_position

	if velocity.length() > 1.0:
		var tilt_amount = clamp(
			velocity.x / 200.0,
			-1.0,
			1.0
		)
		
		var target_rot = deg_to_rad(max_tilt_deg) * tilt_amount
		rotation = lerp_angle(rotation, target_rot, tilt_smooth * delta)
	else:
		# return to neutral
		rotation = lerp_angle(rotation, 0.0, tilt_smooth * delta)
