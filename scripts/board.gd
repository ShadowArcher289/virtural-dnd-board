extends Node3D

@onready var camera_3d: FreeLookCamera = $Setup/Camera3D
@onready var map: CSGBox3D = $Map

@onready var camera_2d_toggle_marker: Marker3D = $Camera2DToggleMarker ## marks where the camera will be placed when being toggled to 2D
@onready var previous_camera_3d_position_marker: Marker3D = $PreviousCamera3DPositionMarker ## used to store the position and rotation of the camera in 3D before it switches to 2D

func _ready() -> void:
	SignalBus.toggled_2d.connect(_2d_views_toggled);

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		pass;
		#print(event.relative) # prints the velocity of the mouse
	if event.is_action_pressed("left_click"):
		shoot_camera_ray();
		shoot_selectior_ray();

func _process(_delta: float) -> void:
	if(Input.is_action_pressed("left_click")): # shoot a camera ray on left click
		shoot_camera_ray();
		shoot_selectior_ray();

func shoot_camera_ray(): ## shoots a ray from a mouse click, clicking an object in 3D space
	var mouse_pos = get_viewport().get_mouse_position();
	var ray_length = 2000;
	var from = camera_3d.project_ray_origin(mouse_pos);
	var to = from + camera_3d.project_ray_normal(mouse_pos) * ray_length;
	var space = get_world_3d().direct_space_state;
	var ray_query = PhysicsRayQueryParameters3D.new();
	ray_query.from = from;
	ray_query.to = to;
	
	# exclude collision layer 2
	ray_query.collision_mask = ~ (1 << 1);
	
	var raycast_result = space.intersect_ray(ray_query);
	#print_debug(raycast_result);
	MouseCollision.mouse_raycast_data = raycast_result;
	
func shoot_selectior_ray(): ## shoots a ray from a mouse click. Used for positioning objects, ignoring object bases.
	pass;
	var mouse_pos = get_viewport().get_mouse_position();
	var ray_length = 2000;
	var from = camera_3d.project_ray_origin(mouse_pos);
	var to = from + camera_3d.project_ray_normal(mouse_pos) * ray_length;
	var space = get_world_3d().direct_space_state;
	var ray_query = PhysicsRayQueryParameters3D.new();
	ray_query.from = from;
	ray_query.to = to;
	
	var raycast_result = space.intersect_ray(ray_query);
	#print_debug(raycast_result);
	MouseCollision.mouse_selector_raycast_data = raycast_result;
	MouseCollision.mouse_raycast_collider = raycast_result.get("collider");
	
	if MouseCollision.mouse_raycast_collider && MouseCollision.mouse_raycast_collider.get_parent().has_method("click"): # if the selected object has a click() method, then run it.
		MouseCollision.mouse_raycast_collider.get_parent().click();
	
	SignalBus.mouse_collided.emit();

func _2d_views_toggled(toggled: bool) -> void: ## handle being toggled between 2D&3D view
	if(toggled):
		previous_camera_3d_position_marker.global_position = camera_3d.global_position;
		previous_camera_3d_position_marker.rotation = camera_3d.rotation;
		camera_3d.look_at(Vector3(camera_3d.global_position.x, 0, camera_3d.global_position.z));
		camera_3d.global_position = camera_2d_toggle_marker.global_position;
	elif(!toggled):
		camera_3d.global_position = previous_camera_3d_position_marker.global_position;
		camera_3d.rotation = previous_camera_3d_position_marker.rotation;
