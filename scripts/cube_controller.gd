extends RigidBody3D

@export var force := 1.5
@export var forward_force = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	



func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		print(event_position)
		move_cube(event_position)


func move_cube(mouse_pressed_position: Vector3):
	print(global_position)
	print(global_position - mouse_pressed_position  * forward_force)
	print("  ")
	apply_impulse((global_position - mouse_pressed_position) * force, mouse_pressed_position)
	
	
	
