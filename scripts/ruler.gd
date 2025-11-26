extends Node3D

@onready var point_1: MeshInstance3D = $Point1
@onready var point_2: MeshInstance3D = $Point2
@onready var line: MeshInstance3D = $Line
@onready var distance: Label3D = $Line/Distance

enum State {
	PLACE_POINT_1,
	PLACE_POINT_2,
	IDLE
}

const RULER_DISTANCE_MULTIPLIER = 6; ## Number to multiply the raw distance to get the D&D 5m per square distance

var current_state = State.IDLE;

func _input(event: InputEvent) -> void:
	if(MouseCollision.currentState("measure")):
		if(event.is_action_pressed("left_click")):
			print_debug("Ruler placed point_1");
			point_1.show();
			switchState("place_point_1");
			#point_1.global_position = MouseCollision.mouse_raycast_data.get("position");
		elif(event.is_action_pressed("right_click")):
			print_debug("Ruler placed point_2");
			point_2.show();
			switchState("place_point_2");
			#point_2.global_position = MouseCollision.mouse_raycast_data.get("position");

func _process(_delta: float) -> void:
	
	if MouseCollision.mouse_raycast_data != null && MouseCollision.mouse_raycast_data.get("position") != null && MouseCollision.currentState("measure"):
		match current_state:
			State.PLACE_POINT_1:
				point_1.global_position = MouseCollision.mouse_raycast_data.get("position");
			State.PLACE_POINT_2:
				point_2.global_position = MouseCollision.mouse_raycast_data.get("position");
	
	placeLine();

func placeLine() -> void:
	if(point_1.is_visible_in_tree() && point_2.is_visible_in_tree()): # show the line only if both points are visible
		line.show();
		
		# set the line to be in-between the two points
		line.global_position = ((point_2.global_position - point_1.global_position)/2) + point_1.global_position;
		line.mesh.height = sqrt(pow(abs(point_2.global_position.x - point_1.global_position.x), 2) + pow(abs(point_2.global_position.y - point_1.global_position.y), 2) + pow(abs(point_2.global_position.z - point_1.global_position.z), 2));
		if(point_1.global_position != point_2.global_position):
			line.look_at(point_2.global_position); # line's rotation
			line.rotation_degrees.x += 90;
		else:
			line.hide();
		
		distance.text = str((round(line.mesh.height * 100)/100) * RULER_DISTANCE_MULTIPLIER) + "m";
	else: # hide the line otherwise
		line.hide();
	
func switchState(state: String) -> void: ## Switch the ruler's state
	match state.to_lower():
		"place_point_1":
			current_state = State.PLACE_POINT_1;
		"place_point_2":
			current_state = State.PLACE_POINT_2;
		_:
			print_debug("Invalid State: " + state);
