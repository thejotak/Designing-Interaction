extends Node

signal dampness_changed(change: float)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_add_dampness"):
		dampness_changed.emit(0.1)
		print("dampness changed by +0.1")
		
	if event.is_action_pressed("debug_remove_dampness"):
		dampness_changed.emit(-0.1)
		print("dampness changed by -0.1")
