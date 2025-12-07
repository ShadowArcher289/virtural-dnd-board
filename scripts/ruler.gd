extends Node3D

@onready var point_1: MeshInstance3D = $Point1
@onready var point_2: MeshInstance3D = $Point2
@onready var main_line: MeshInstance3D = $MainLine
@onready var distance: Label3D = $MainLine/Distance

enum PlaceState { ## The state for placing a point
	PLACE_POINT_1,
	PLACE_POINT_2,
	IDLE
}

enum State {
	RULER,
	ATK_AOE_CONE,
	ATK_AOE_CIRCLE,
	ATK_AOE_SQUARE
}

const RULER_DISTANCE_MULTIPLIER = 6; ## Number to multiply the raw distance to get the D&D 5m per square distance

var current_place_state = PlaceState.IDLE;
var current_state = State.RULER;

var switch_count = 0;

func _input(event: InputEvent) -> void:
	if(MouseCollision.currentState("measure")):
		if(event.is_action_pressed("left_click")):
			switch_state("place_point_1");
			await get_tree().create_timer(0.01).timeout;
			switch_state("place_point_2");
		if(event.is_action_released("left_click")):
			switch_state("idle");
			#print_debug("Ruler placed point_1");
			#point_1.show();
			#switch_state("place_point_1");
			##point_1.global_position = MouseCollision.mouse_raycast_data.get("position");
		#elif(event.is_action_pressed("right_click")):
			#print_debug("Ruler placed point_2");
			#point_2.show();
			#switch_state("place_point_2");
			##point_2.global_position = MouseCollision.mouse_raycast_data.get("position");

func _process(_delta: float) -> void:
	
	if MouseCollision.mouse_raycast_data != null && MouseCollision.mouse_raycast_data.get("position") != null && MouseCollision.currentState("measure"):
		
		match current_place_state:
			PlaceState.PLACE_POINT_1:
				point_1.show();
				point_1.global_position = MouseCollision.mouse_raycast_data.get("position");
			PlaceState.PLACE_POINT_2:
				point_1.show(); # if point 2 is placed, then point_1 should already be in a valid place
				point_2.show();
				point_2.global_position = MouseCollision.mouse_raycast_data.get("position");
	elif(!MouseCollision.currentState("measure") || !MouseCollision.currentState("attack_area")):
		point_1.hide();
		point_2.hide();
	
	match current_state:
		State.RULER:
			place_line(point_1, point_2, main_line);
			

#func place_point() -> void: ## place points 1 and 2 on the map.
	#match switch_count:
		#0:
			#print_debug("Ruler placed point_1");
			#point_1.show();
			#switch_state("place_point_1");
		#1:
			#print_debug("Ruler placed point_2");
			#point_2.show();
			#switch_state("place_point_2");
		#2:
			#print_debug("Ruler in Idle");
			#switch_state("idle");
		#_:
			#print_debug("Invalid switch_count number: " + str(switch_count));
	#
	#if(switch_count < 2):
		#switch_count += 1;
	#else:
		#switch_count = 0;


func switch_state(state: String) -> void: ## Switch the ruler's state
	match state.to_lower():
		"place_point_1":
			current_place_state = PlaceState.PLACE_POINT_1;
		"place_point_2":
			current_place_state = PlaceState.PLACE_POINT_2;
		"idle":
			current_place_state = PlaceState.IDLE;
		_:
			print_debug("Invalid State: " + state);

func place_line(p1: MeshInstance3D, p2: MeshInstance3D, given_line: MeshInstance3D) -> void: ## place a given line between two given points
	if(p1.is_visible_in_tree() && p2.is_visible_in_tree()): # show the line only if both points are visible
		given_line.show();
		
		# set the line to be in-between the two points
		given_line.global_position = ((p2.global_position - p1.global_position)/2) + p1.global_position;
		given_line.mesh.height = sqrt(pow(abs(p2.global_position.x - p1.global_position.x), 2) + pow(abs(p2.global_position.y - p1.global_position.y), 2) + pow(abs(p2.global_position.z - p1.global_position.z), 2));
		if(p1.global_position != p2.global_position):
			given_line.look_at(p2.global_position); # line's rotation
			given_line.rotation_degrees.x += 90;
		else:
			given_line.hide();
		
		distance.text = str((round(main_line.mesh.height * 100)/100) * RULER_DISTANCE_MULTIPLIER) + "m";
	else: # hide the line otherwise
		given_line.hide();

func place_circle(p1: MeshInstance3D, p2: MeshInstance3D, given_circle: MeshInstance3D) -> void: ## place a given circle with a radius of the distance between two given points and centered at p1.
	pass;
