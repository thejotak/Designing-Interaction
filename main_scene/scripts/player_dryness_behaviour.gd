extends Node

@export var player : RigidBody3D

@export var start_color : Color
@export var end_color : Color

@export var start_uv1_scale : Vector3
@export var end_uv1_scale : Vector3

@export var start_up_force : float
@export var end_up_force : float

@export var start_forward_force : float
@export var end_forward_force : float

var t : float = 0

@export var time_to_dry_out := 20.0
var is_drying_out = false

signal change_shape(shape_change)

var mesh_node
var material : BaseMaterial3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Get material
	mesh_node = GenericFunctions.get_sibling_by_type(get_parent(), MeshInstance3D)
	material = mesh_node.get_active_material(0)
	
	material.albedo_color = start_color
	material.uv1_scale = start_uv1_scale
	
	start_drying_out()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (is_drying_out):
		t += delta
		
		# Change color
		var new_color = update_variable(start_color, end_color)
		material.albedo_color = new_color
		
		# Change size of noise (UV1)
		var new_uv1_scale = update_variable(start_uv1_scale, end_uv1_scale)
		material.uv1_scale = new_uv1_scale
		
		# Change up_force
		var new_up_force = update_variable(start_up_force, end_up_force)
		player.up_force = new_up_force
		
		# Change forward_force
		var new_forward_force = update_variable(start_forward_force, end_forward_force)
		player.forward_force = new_forward_force
		
		
		# Change Shape
		change_shape.emit(delta/time_to_dry_out)
		
		
		if (t >= time_to_dry_out):
			is_drying_out = false
	

func update_variable(start_value, end_value,):
	var difference = end_value - start_value
	var new_value = start_value + difference * (t/time_to_dry_out)
	return new_value

func start_drying_out():
	t = 0
	is_drying_out = true
