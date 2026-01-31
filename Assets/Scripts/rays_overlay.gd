extends Sprite2D
@export var camera_path: NodePath
@onready var cam: Camera2D = get_node(camera_path)

func _process(_delta):
	# slight parallax so it feels like it's in the world
	global_position = cam.global_position * 0.9
