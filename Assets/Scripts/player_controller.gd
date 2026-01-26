extends CharacterBody2D
class_name PlayerController

@export var camera : Camera2D

@export var speed = 10.0
@export var jump_power = 10.0
@export var dash_speed := 800.0 #higher number, more distance
@export var dash_duration := 0.12 
@export var dash_decay := 6000.0 #higher number, less distance
@export var dash_cooldown := 0.6
@export var ladder_speed = 3.0

var speed_multiplier = 30.0
var sprint_multiplier = 1.5
var jump_multiplier = -30.0
var direction := 0.0
var jump_count = 0
var is_dashing := false
var dash_time := 0.0
var dash_cooldown_time := 0.0
var last_facing_direction := 1.0 

var is_on_ladder := false 
var is_climbing := false 

func _physics_process(delta: float) -> void:
	# DASH HANDLING
	if dash_cooldown_time > 0:
		dash_cooldown_time -= delta
	
	if is_dashing:
		dash_time -= delta
		velocity.y = 0
		velocity.x = move_toward(velocity.x, 0, dash_decay * delta)
		
		if dash_time <= 0:
			is_dashing = false
		
		move_and_slide()
		return
	
	# GRAVITY
	if not is_on_floor():
		velocity += get_gravity() * delta 
	else:
		jump_count = 0
	
	# JUMP
	if Input.is_action_just_pressed("jump"):		
		var jump_boost := 0.0 
		if jump_count < 2:
			# if double jump, shake camera - also make it stronger
			if camera and jump_count == 1:
				jump_boost = 2.0
				camera.shake(1.5)
				
			velocity.y = (jump_power + jump_boost) * jump_multiplier
		jump_count += 1
	
	# DASH INPUT
	if Input.is_action_just_pressed("dash") and dash_cooldown_time <= 0:
		start_dash()
		return  
	
	# MOVEMENT 
	direction = Input.get_axis("move_left", "move_right")
	var current_speed = speed * speed_multiplier
	
	# UPDATE HORIZONTAL VELOCITY
	if direction != 0:
		last_facing_direction = sign(direction)
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
	
	# Ladder climbing
	if is_on_ladder:	
		if Input.is_action_just_pressed("climb_up") or Input.is_action_just_pressed("climb_down"):
			is_climbing = true
		
	if is_climbing:
		velocity.y = (
			Input.get_action_strength("climb_down")
			- Input.get_action_strength("climb_up")
		) * ladder_speed
		jump_count = 1

		
	move_and_slide()
	
func start_dash():
	is_dashing = true
	dash_time = dash_duration
	dash_cooldown_time = dash_cooldown
	
	var dash_dir = sign(direction)
	if dash_dir == 0:
		dash_dir = last_facing_direction
	
	velocity.x = dash_dir * dash_speed
	velocity.y = 0
	
	if camera: 
		camera.shake(1.5)


func _on_interaction_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("Ladder"):
		is_on_ladder = true


func _on_interaction_detector_area_exited(area: Area2D) -> void:
	if area.is_in_group("Ladder"):
		is_on_ladder = false
		is_climbing = false
	
