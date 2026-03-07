extends RigidBody3D

var original_dampness

@export var cube : RigidBody3D
@export var ball : RigidBody3D


# dampness ranges from 0 to 1
# starting value is 0.5
var dampness := 0.5
@export var Dampness := 0.5 :
	get:
		return dampness
	set(value):
		original_dampness = dampness
		dampness = value
		dampness_changed(value, original_dampness)
		print("test")
		


func dampness_changed(new_value: int, original_value: int):
	var change_in_dampness = original_value - new_value
	
	print("Dampness changed by:")
	print(change_in_dampness)
	
	# Cube
	#cube.scale_object_local(Vector3.ONE * (1 + change_in_dampness))
	get_parent().get_node("cube").scale *= (1 + change_in_dampness)
	
	# Ball
	ball.scale_object_local(Vector3.ONE * (1 - change_in_dampness))
	
# 1 - verandering = modifier 
# 1 + verandering = modifier
