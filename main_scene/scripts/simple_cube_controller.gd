extends RigidBody3D

#@export var force := 1.5


@export var forward_force = 1
@export var up_force = 1
@export var press_cooldown := 0.5

@export var camera : Camera3D


var direction3D





func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	
	if event is InputEventMouseButton: 
		if  event.is_pressed():
			print("The cube has been clicked!")
			move_cube(event_position)
			
			
			
func move_cube(mouse_pressed_position: Vector3):
	
	if $Timer.is_stopped():
		direction3D = global_position - camera.global_position
		var direction2D = Vector2(direction3D.x, direction3D.z)
		direction2D = direction2D.normalized()
		
		direction3D.y = up_force
		direction2D *= forward_force
		
		direction3D.x = direction2D.x
		direction3D.z = direction2D.y
		
		apply_impulse(direction3D, camera.global_position)
		$Timer.start(press_cooldown)
	
	
	#print(global_position)
	#print(global_position - mouse_pressed_position  * forward_force)
	#print("  ")
	#apply_impulse((global_position - mouse_pressed_position) * force, mouse_pressed_position)
	
	
	
