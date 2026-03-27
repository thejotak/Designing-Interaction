extends Area3D

@export var player : RigidBody3D
var player_start_pos

func _ready() -> void:
	body_entered.connect(die.bind())
	player_start_pos = player.position


func die(node):
	print("you died!")
	player.position = player_start_pos
	player.linear_velocity = Vector3.ZERO
