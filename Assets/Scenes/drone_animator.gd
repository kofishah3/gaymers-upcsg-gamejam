extends Node2D

@export var drone_controller: CharacterBody2D
@export var sprite : Sprite2D
@export var light_occluder: LightOccluder2D

var direction := 0

func _process(_delta):
	if !drone_controller or !sprite: 
		return 
	
	if Input.is_action_just_pressed("move_left"):
		sprite.flip_h = true		
		direction = 1
	elif Input.is_action_just_pressed("move_right"):
		sprite.flip_h = false
		direction = -1
	
	if abs(drone_controller.velocity.x) > 50.0: 
		drone_controller.follow_offset = Vector2(20 * direction, -25)
