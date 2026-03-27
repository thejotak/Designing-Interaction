extends Node

@export var player : RigidBody3D
@export var becomeing_square_paritcles : GPUParticles3D
@export var becomeing_round_particles : GPUParticles3D
@export var particle_attractor : Node3D

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


@export var t : float = 0
var old_t : float = 0

enum player_state 
{
	becoming_cube = -1,
	stable = 0,
	becoming_sphere = 1,
}
var state : player_state = player_state.stable
var enter_exit_buffer := 0

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
	
	
	set_dryness()
	
	for  wet_surface in get_tree().get_nodes_in_group("wet_surface"):
		var area = GenericFunctions.find_node_in_children(wet_surface, Area3D)
		area.connect("body_entered", become_round.bind())
		area.connect("body_exited", become_stable_exited.bind())
	
	for  hot_surface in get_tree().get_nodes_in_group("hot_surface"):
		var area = GenericFunctions.find_node_in_children(hot_surface, Area3D)
		area.connect("body_entered", become_square.bind())
		area.connect("body_exited", become_stable_exited.bind())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == player_state.becoming_cube:
		t -= delta
		
	
	if state == player_state.becoming_sphere:
		t += delta
	
	if (state == player_state.becoming_cube || state == player_state.becoming_sphere):
		change_dryness()
		update_shape()
	
	

# Not working I think
func set_dryness():
	state = player_state.becoming_sphere
	change_dryness()
	
	
	become_stable()
	
func reset_dryness(node):
	state = player_state.becoming_cube
	
	# Change the shape by negative * all the change that has happened
	change_shape.emit(-t/time_to_dry_out)
	
	# Change t to 0 so when the variables are updated, the start_value is applied
	t = 0
	change_dryness()
	
	become_stable()

func change_dryness():
	
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
		

func update_shape():
	# Change Shape
	change_shape.emit((t - old_t)/time_to_dry_out * state)
	old_t = t
	
	if (t >= time_to_dry_out - 0.05):
		print("the cube is completely wet!")
		become_stable()
		
	if (t <= -0.05):
		print("The cube is comepletely dry!")
		become_stable()


func update_variable(start_value, end_value):
	var difference = end_value - start_value
	var new_value = start_value + difference * (t/time_to_dry_out)
	return new_value

func become_stable():
	
	state = player_state.stable
	print("The cube is stable!")
	
	becomeing_square_paritcles.emitting = false
	becomeing_round_particles.emitting = false
	particle_attractor.process_mode = Node.PROCESS_MODE_DISABLED
	particle_attractor.visible = false

func become_stable_exited(node: Node3D):
	if (node.is_in_group("player")):
		
		enter_exit_buffer -= 1
		if enter_exit_buffer > 0:
			
			print("not stabilizing in between surfaces")
			print(enter_exit_buffer)
			return
		
		become_stable()

func become_round(node: Node3D):
	if (node.is_in_group("player")):
		enter_exit_buffer += 1
		print(enter_exit_buffer)
		
		state = player_state.becoming_sphere
		print("The cube is becoming rounder!")
		
		becomeing_round_particles.emitting = true
		particle_attractor.process_mode = Node.PROCESS_MODE_INHERIT
		particle_attractor.visible = true

func become_square(node: Node3D):
	if (node.is_in_group("player")):
		enter_exit_buffer += 1
		print(enter_exit_buffer)
		
		state = player_state.becoming_cube
		print("The cube is becoming more square!") 
		
		becomeing_square_paritcles.emitting = true
