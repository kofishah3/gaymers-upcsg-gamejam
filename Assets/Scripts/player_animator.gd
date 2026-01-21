extends Node2D

@export var player_controller : PlayerController
@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D

func _process(delta):
	# SPRITE FLIP
	if player_controller.direction > 0:
		sprite.flip_h = false
	elif player_controller.direction < 0:
		sprite.flip_h = true

	# ANIMATION SELECTION (priority-based)
	var anim := "idle"

	if player_controller.velocity.y < 0:
		anim = "jump"
	elif player_controller.velocity.y > 0:
		anim = "fall"
	elif abs(player_controller.velocity.x) > 0:
		if player_controller.is_sprinting:
			anim = "running"
		else:
			anim = "walking"

	# Play only if changed (VERY important)
	if animation_player.current_animation != anim:
		animation_player.play(anim)
