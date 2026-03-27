extends Node3D

@export var rotation_speed = 0.2


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("move_camera_left"):
		rotate_y(-rotation_speed)
	if event.is_action("move_camera_right"):
		rotate_y(rotation_speed)
	if event is InputEventScreenDrag:
		if !$"../Player".touch_pressed:
			rotate_y(event.screen_relative.x *0.007)


func _on_dampness_debug_input_dampness_changed(change: float) -> void:
	pass # Replace with function body.
