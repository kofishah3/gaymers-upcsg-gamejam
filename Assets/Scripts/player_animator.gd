extends Node2D

@export var player_controller : PlayerController
@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D

func _process(delta):	
	#character srite flipping
	if player_controller.direction == 1:
		sprite.flip_h = false
	elif player_controller.direction == -1:
		sprite.flip_h = true
	
	#movement animation handling	
	if abs(player_controller.velocity.x) > 0:
		animation_player.play("walking")
	else: 
		animation_player.play("idle")
	
	#plays jump animation
	if player_controller.velocity.y < 0:
		animation_player.play("jump") #temporary will be replaced with jumping
	elif player_controller.velocity.y > 0:
		animation_player.play("fall") #temporary will be replaced with falling
