extends Node

@export var cube_transformer : RigidBody3D

var new_node
func _ready() -> void:
	new_node = Node3D.new()
	add_child(new_node)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_add_dampness"):
		cube_transformer.Dampness += 0.1
		
	if event.is_action_pressed("debug_remove_dampness"):
		cube_transformer.Dampness -= 0.1
