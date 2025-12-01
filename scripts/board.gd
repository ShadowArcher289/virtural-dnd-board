extends Node3D

@onready var camera_3d: FreeLookCamera = $Setup/Camera3D


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		pass;
		#print(event.relative) # prints the velocity of the mouse
	if event.is_action_pressed("left_click"):
		shoot_camera_ray();

func _process(_delta: float) -> void:
	set_process_unhandled_input(true);
	if(Input.is_action_pressed("left_click")):
		shoot_camera_ray();

func shoot_camera_ray(): ## shoots an array from a mouse click, clicking an object in 3D space.
	var mouse_pos = get_viewport().get_mouse_position();
	var ray_length = 1000;
	var from = camera_3d.project_ray_origin(mouse_pos);
	var to = from + camera_3d.project_ray_normal(mouse_pos) * ray_length;
	var space = get_world_3d().direct_space_state;
	var ray_query = PhysicsRayQueryParameters3D.new();
	ray_query.from = from;
	ray_query.to = to;
	var raycast_result = space.intersect_ray(ray_query);
	#print_debug(raycast_result);
	MouseCollision.mouse_raycast_data = raycast_result;
	MouseCollision.mouse_raycast_collider = raycast_result.get("collider");
	
	if MouseCollision.mouse_raycast_collider && MouseCollision.mouse_raycast_collider.get_parent().has_method("click"): # if the selected object has a click() method, then run it.
		MouseCollision.mouse_raycast_collider.get_parent().click();
	
	SignalBus.mouse_collided.emit();
