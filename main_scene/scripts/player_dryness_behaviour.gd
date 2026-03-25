extends Node

@export var player : RigidBody3D
@export var becomeing_square_paritcles : GPUParticles3D
@export var becomeing_round_particles : GPUParticles3D
@export var particle_attractor : Node

@export var start_color : Color
@export var end_color : Color

@export var start_uv1_scale : Vector3
@export var end_uv1_scale : Vector3

@export var start_up_force : float
@export var end_up_force : float

@export var start_forward_force : float
@export var end_forward_force : float

@export var start_mass : float
@export var end_mass : float


var t : float = 0

enum player_state 
{
	becoming_cube = -1,
	stable = 0,
	becoming_sphere = 1,
}
var state : player_state = player_state.stable

@export var time_to_dry_out := 20.0

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
	
	t = 0
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == player_state.becoming_cube:
		t -= delta
		
	
	if state == player_state.becoming_sphere:
		t += delta
	
	
	if (state == player_state.becoming_cube || state == player_state.becoming_sphere):
		
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
		
		# Change mass
		var new_mass = update_variable(start_mass, end_mass)
		player.mass = new_mass
		
		
		# Change Shape
		change_shape.emit(delta/time_to_dry_out * state)
		
		
		if (t >= time_to_dry_out):
			print("the cube is completely wet!")
			become_stable(player)
			
		if (t <= 0):
			print("The cube is comepletely dry!")
			become_stable(player)
	

func update_variable(start_value, end_value):
	var difference = end_value - start_value
	var new_value = start_value + difference * (t/time_to_dry_out)
	return new_value



func become_stable(node: Node3D):
	if (node.is_in_group("player")):
		state = player_state.stable
		print("The cube is stable!")
		
		becomeing_square_paritcles.emitting = false
		becomeing_round_particles.emitting = false
		particle_attractor.process_mode = Node.PROCESS_MODE_DISABLED

func become_round(node: Node3D):
	if (node.is_in_group("player")):
		state = player_state.becoming_sphere
		print("The cube is becoming rounder!")
		
		becomeing_round_particles.emitting = true
		particle_attractor.process_mode = Node.PROCESS_MODE_INHERIT

func become_square(node: Node3D):
	if (node.is_in_group("player")):
		state = player_state.becoming_cube
		print("The cube is becoming more square!") 
		
		becomeing_square_paritcles.emitting = true
