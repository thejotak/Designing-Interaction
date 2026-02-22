extends RigidBody3D

#@export var force := 1.5


@export var forward_force = 1
@export var up_force = 1

@export var sustained_force = 1
@export var long_press_limit = 100

var press_duration : int
var on_press_ticks : int
var on_release_ticks : int
var time_since_press 

var is_clicking := false

var direction3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	



func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton: 
		
		
		if  event.is_pressed():
			
			
			print("The cube has been clicked!")
			#print(event_position)
			on_press_ticks = Time.get_ticks_msec()
			move_cube(event_position)
			
		if event.is_released():
			is_clicking = false
			
			on_release_ticks = Time.get_ticks_msec()
			press_duration = on_release_ticks - on_press_ticks
			
			print(on_press_ticks)
			print(on_release_ticks)
			print(press_duration)
			
			on_press_ticks = 0
			on_release_ticks = 0
			press_duration = 0

func _physics_process(delta: float) -> void:
	if is_clicking:
		time_since_press = Time.get_ticks_msec() - on_press_ticks 
		if  time_since_press <= long_press_limit: 
			apply_force(direction3D * sustained_force, )
			print(time_since_press)

func move_cube(mouse_pressed_position: Vector3):
	
	direction3D = global_position - mouse_pressed_position
	var direction2D = Vector2(direction3D.x, direction3D.z)
	direction2D = direction2D.normalized()
	
	direction3D.y = up_force
	direction2D *= forward_force
	
	direction3D.x = direction2D.x
	direction3D.z = direction2D.y
	
	apply_impulse(direction3D, mouse_pressed_position)
	is_clicking = true
	
	
	#print(global_position)
	#print(global_position - mouse_pressed_position  * forward_force)
	#print("  ")
	#apply_impulse((global_position - mouse_pressed_position) * force, mouse_pressed_position)
	
	
	
