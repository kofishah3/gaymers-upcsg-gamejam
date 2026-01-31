extends GPUParticles2D
@export var camera_path: NodePath
@export var cam : Camera2D

func _process(_delta):
	global_position = cam.global_position
