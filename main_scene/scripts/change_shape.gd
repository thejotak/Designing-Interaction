extends MeshInstance3D

signal shape_changed(shape: Shape3D)

func change_shape(change: float):
	
	# Change the blend value
	set_blend_shape_value(0, get_blend_shape_value(0) + change )
	
	# Create the current blendshape mesh
	var mesh_array : ArrayMesh = bake_mesh_from_current_blend_shape_mix()
	
	# Create a mesh instance with the new mesh 
	var new_mesh = MeshInstance3D.new()
	new_mesh.mesh = mesh_array
	add_child(new_mesh)
	
	# Make a child staticbody that has the shape we want
	new_mesh.create_convex_collision()
	
	
	# Fetch the shape
	var shape : Shape3D
	var collision_kid = GenericFunctions.find_node_in_children(self, CollisionShape3D)
	shape = collision_kid.shape
	
	# Emit the shape
	shape_changed.emit(shape)
	

	
