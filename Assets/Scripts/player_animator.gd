extends Node2D

@export var player_controller : PlayerController
@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D
@export var jump_particles: CPUParticles2D

@export var jump_stretch := Vector2(1.05, 0.95)
@export var land_squash := Vector2(1.05, 0.95)
@export var scale_return_speed := 10.0

var was_on_floor := false

func _process(delta):
	# SPRITE FLIP (locked during dash)
	if not player_controller.is_dashing:
		if player_controller.direction > 0:
			sprite.flip_h = false
		elif player_controller.direction < 0:
			sprite.flip_h = true

	# ANIMATION SELECTION (priority-based)
	var anim := "idle"

	if player_controller.is_dashing:
		anim = "dash"
	elif Input.get_action_strength("climb_down") or Input.get_action_strength("climb_up") and player_controller.is_climbing:
		anim = "climbing"
		
	elif player_controller.velocity.y < 0:
		anim = "jump"
		sprite.scale = jump_stretch
		
		if player_controller.jump_count == 2:
			jump_particles.emitting = true
	elif player_controller.velocity.y > 0:
		anim = "fall"
	elif abs(player_controller.velocity.x) > 0:
		anim = "walking"

	# LANDING SQUASH (detect transition)
	if not was_on_floor and player_controller.is_on_floor():
		sprite.scale = land_squash

	# Return to normal scale
	sprite.scale = sprite.scale.lerp(Vector2.ONE, scale_return_speed * delta)

	# Play only if changed
	if animation_player.current_animation != anim:
		animation_player.play(anim)

	was_on_floor = player_controller.is_on_floor()
