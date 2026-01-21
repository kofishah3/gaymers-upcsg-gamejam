extends CharacterBody2D
class_name PlayerController

@export var speed = 10.0
@export var jump_power = 10.0

var speed_multiplier = 30.0
var sprint_multiplier = 1.5
var jump_multiplier = -30.0

var direction := 0
var jump_count = 0
var is_sprinting := false

func _physics_process(delta: float) -> void:
	# GRAVITY
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_floor():
		jump_count = 0

	# JUMP
	if Input.is_action_just_pressed("jump"):
		if jump_count < 2:			
			velocity.y = jump_power * jump_multiplier
		jump_count += 1								
	
	# MOVEMENT
	direction = Input.get_axis("move_left", "move_right")

	is_sprinting = Input.is_action_pressed("sprint") and direction != 0 and is_on_floor()

	var current_speed = speed * speed_multiplier
	if is_sprinting:
		current_speed *= sprint_multiplier

	if direction != 0:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

	move_and_slide()
