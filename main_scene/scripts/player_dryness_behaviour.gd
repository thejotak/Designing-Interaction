extends Node

@export var start_color : Color
@export var end_color : Color

var t : float = 0

var time_to_dry_out := 20.0
var is_drying_out = false

signal change_shape(shape_change)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_drying_out()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (is_drying_out):
		t += delta
		
		# Get material
		var mesh_node = GenericFunctions.get_sibling_by_type(get_parent(), MeshInstance3D)
		var material : Material = mesh_node.get_active_material(0)
		
		# Change color
		var color_difference = end_color - start_color
		var new_color = start_color + color_difference * (t/time_to_dry_out)
		material.albedo_color = new_color
		
		# Change Shape
		change_shape.emit(delta/time_to_dry_out)
		
		
		if (t >= time_to_dry_out):
			is_drying_out = false
	

func start_drying_out():
	t = 0
	is_drying_out = true
