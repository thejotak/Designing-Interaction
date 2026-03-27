extends RigidBody3D

@export var forward_force = 1
@export var up_force = 1
@export var press_cooldown := 0.5

@export var nudge_power := 0.2

@export var touch_forward_force := 1.0

@export var camera : Camera3D

var direction3D
var touch_pressed = true





func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	
	if event is InputEventMouseButton: 
		if  event.is_pressed():
			print("The cube has been clicked!")
			move_cube()
			
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_pressed = true
	if event is InputEventScreenDrag:
		event.screen_velocity


func _input(event: InputEvent) -> void:
	if touch_pressed:
		if event is InputEventScreenTouch:
			if event.pressed == false:
				touch_pressed = false

func move_cube():
	
	if $Timer.is_stopped():
		direction3D = global_position - camera.global_position
		var direction2D = Vector2(direction3D.x, direction3D.z)
		direction2D = direction2D.normalized()
		
		
		direction3D.y = up_force
		direction2D *= forward_force
		
		
		direction3D.x = direction2D.x
		direction3D.z = direction2D.y
		
		apply_impulse(direction3D, Vector3(0, 1, 0))
		$Timer.start(press_cooldown)
		

func move_cube_with_touch(event: InputEventScreenDrag):
	if touch_pressed:
		var velocity = event.screen_velocity * touch_forward_force
		var direction = Vector3(velocity.x, velocity.y, up_force)
	
		apply_force(direction)

#func change_dryness_appearance(change: float ):
	#pass
	## This function changes the appearance of the player cube 
	## after a change in shape has happenend
	#
	## Change color
	#var mesh = GenericFunctions.find_node_in_children(self, MeshInstance3D)
	#mesh
	#
	## Change material


func _on_mouse_entered() -> void:
	if $Timer.is_stopped():
		#var mouse_pos = camera.get_viewport().get_mouse_position()
		#var depth = position.distance_to(camera.position)
	#
		#var mouse_world_position = camera.project_position(mouse_pos, depth)
	#
		#var nudge_direction = position.direction_to(mouse_world_position)
	
		direction3D = global_position - camera.global_position
		var direction2D = Vector2(direction3D.x, direction3D.z)
		direction2D = direction2D.normalized()
		
		
		direction3D.y = up_force
		direction2D *= forward_force
		
		
		direction3D.x = direction2D.x
		direction3D.z = direction2D.y
		
		
		apply_impulse(direction3D * nudge_power, Vector3(0, 1, 0))
	
	
	
	
