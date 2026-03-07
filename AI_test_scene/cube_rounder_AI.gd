# RigidBody3D.gd
extends RigidBody3D

@export var size : Vector3 = Vector3.ONE          # base cube size
@export var corner_radius : float = 0.2           # radius of rounded corners
@export var subdivisions : int = 2                # how many extra verts per edge (higher = smoother)

@export var mesh_instance : MeshInstance3D
@export var collision_shape : CollisionShape3D

func _ready():
	
	

	_rebuild()

# -------------------------------------------------------------------------
# Public API – call this to change the shape while the game runs
# -------------------------------------------------------------------------
func set_corner_radius(r : float) -> void:
	corner_radius = r
	_rebuild()

func push_face(normal : Vector3, distance : float) -> void:
	# Move all vertices whose dot(normal, vertex) > threshold
	var verts = _generate_vertices()
	var thresh = normal.dot(size * 0.5) - 0.001
	for i in verts.size():
		if normal.dot(verts[i]) > thresh:
			verts[i] += normal * distance
	_apply_vertices(verts)

# -------------------------------------------------------------------------
# Internal helpers
# -------------------------------------------------------------------------
func _rebuild() -> void:
	var verts = _generate_vertices()
	_apply_vertices(verts)

func _generate_vertices() -> PackedVector3Array:
	# Start with a regular cube (8 corners)
	var half = size * 0.5
	var base = [
		Vector3(-half.x, -half.y, -half.z),
		Vector3( half.x, -half.y, -half.z),
		Vector3( half.x,  half.y, -half.z),
		Vector3(-half.x,  half.y, -half.z),
		Vector3(-half.x, -half.y,  half.z),
		Vector3( half.x, -half.y,  half.z),
		Vector3( half.x,  half.y,  half.z),
		Vector3(-half.x,  half.y,  half.z)
	]

	# If corner_radius == 0 we can just return the cube vertices.
	if corner_radius <= 0.0:
		return PackedVector3Array(base)

	# Otherwise we replace each corner with a small sphere patch.
	var verts = PackedVector3Array()
	for corner in base:
		# Sample points on a sphere segment around the corner.
		for i in range(subdivisions + 1):
			for j in range(subdivisions + 1):
				var theta = PI * i / (subdivisions * 2)      # polar angle
				var phi   = TAU * j / (subdivisions)         # azimuthal angle
				var dir = Vector3(
					sin(theta) * cos(phi),
					sin(theta) * sin(phi),
					cos(theta)
				)
				# Push the point outwards from the original corner,
				# but keep it inside the original cube bounds.
				var p = corner + dir * corner_radius
				# Clamp to the cube extents so we don’t exceed the original size.
				p.x = clamp(p.x, -half.x, half.x)
				p.y = clamp(p.y, -half.y, half.y)
				p.z = clamp(p.z, -half.z, half.z)
				verts.append(p)
	return verts

func _apply_vertices(verts : PackedVector3Array) -> void:
	# 1️⃣ Build a visual mesh from the vertex list.
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Simple triangulation: we’ll just feed the vertices as a convex hull.
	# For a production‑ready shape you’d want a proper Delaunay/ConvexHull
	# algorithm, but Godot’s ConvexPolygonShape will compute that for us.
	for v in verts:
		st.add_vertex(v)

	var array_mesh : ArrayMesh = st.commit()
	mesh_instance.mesh = array_mesh

	# 2️⃣ Build a physics shape from the same vertices.
	var convex_shape = ConvexPolygonShape3D.new()
	convex_shape.points = verts
	collision_shape.shape = convex_shape
