extends Node3D

@export var rotation_speed = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("move_camera_left"):
		rotate_y(-rotation_speed)
	if event.is_action("move_camera_right"):
		rotate_y(rotation_speed)
