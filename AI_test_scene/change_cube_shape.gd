extends Node

func _ready() -> void:
	add_child(Node.new())

func _on_button_down() -> void:
	print("button down")
	$"../../RigidBody3D".set_corner_radius(0.5)
	
