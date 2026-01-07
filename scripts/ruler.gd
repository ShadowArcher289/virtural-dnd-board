extends Node3D

@onready var point_1: MeshInstance3D = $Point1
@onready var point_2: MeshInstance3D = $Point2

@onready var main_line: MeshInstance3D = $MainLine
@onready var distance: Label3D = $MainLine/Distance

@onready var main_circle: MeshInstance3D = $MainCircle
@onready var radius: Label3D = $MainCircle/Radius

@onready var main_square: MeshInstance3D = $MainSquare
@onready var width: Label3D = $MainSquare/Width

@onready var main_cone: Node3D = $MainCone ## Node to hide all objects of the main cone
@onready var main_cone_parts: Dictionary = {
	"cone_l1": $MainCone/ConeL1, 
	"cone_l2": $MainCone/ConeL2,
	"cone_l3": $MainCone/ConeL3,  
	"cone_p1": $MainCone/ConeL2/ConeP1, 
	"cone_p2": $MainCone/ConeL2/ConeP2
}; ## Dictionary of all the objects used for a cone. numbered from lowest on the left to highest on the right.
@onready var size: Label3D = $MainCone/Size

@onready var main_rectangle: Node3D = $MainRectangle ## Node to hide all objects of the main rectangle
@onready var main_rectangle_parts: Dictionary = {
	"rectangle_ll1": $MainRectangle/RectangleLL1,
	"rectangle_ll2": $MainRectangle/RectangleLL2,
	"rectangle_ls1": $MainRectangle/RectangleLS1,
	"rectangle_ls2": $MainRectangle/RectangleLS2,
	"rectangle_p3": $MainRectangle/RectangleP3,
	"rectangle_p4": $MainRectangle/RectangleP4,
	"rectangle_p5": $MainRectangle/RectangleP5
};
@onready var long_line_size: Label3D = $MainRectangle/LongLineSize
@onready var short_line_size: Label3D = $MainRectangle/ShortLineSize

const RED = "#9c0000";

enum PlaceState { ## The state for placing a point
	PLACE_POINT_1,
	PLACE_POINT_2,
	IDLE
}

enum MeasureState {
	RULER,
	ATK_AOE_CONE,
	ATK_AOE_CIRCLE,
	ATK_AOE_SQUARE,
	ATK_AOE_RECTANGLE
}

const RULER_DISTANCE_MULTIPLIER = 6.67; ## Number to multiply the raw distance to get the D&D 5m per square distance

var current_place_state = PlaceState.IDLE;
var current_measure_state = MeasureState.RULER;

var switch_count = 0;

func _input(event: InputEvent) -> void:
	if(MouseCollision.currentState("measure") || MouseCollision.currentState("attack_area")):
		if(event.is_action_pressed("left_click")):
			switch_point_state("place_point_1");
			await get_tree().create_timer(0.01).timeout;
			switch_point_state("place_point_2");
		if(event.is_action_released("left_click")):
			switch_point_state("idle");

func _ready() -> void:
	distance.no_depth_test = true;
	radius.no_depth_test = true;
	width.no_depth_test = true;
	size.no_depth_test = true;
	long_line_size.no_depth_test = true;
	short_line_size.no_depth_test = true;
	
	distance.render_priority = 1;
	radius.render_priority = 1;
	width.render_priority = 1;
	size.render_priority = 1;
	long_line_size.render_priority = 1;
	short_line_size.render_priority = 1;

func _process(_delta: float) -> void:
	
	# Place points on the map
	if MouseCollision.mouse_raycast_data != null && MouseCollision.mouse_raycast_data.get("position") != null && (MouseCollision.currentState("measure") || MouseCollision.currentState("attack_area")):
		
		if(MouseCollision.currentState("measure")):
			switch_aoe_state("ruler");
		elif(MouseCollision.currentState("attack_area") && current_measure_state == MeasureState.RULER):
			switch_aoe_state("atk_aoe_circle");

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
	
	# Draw the distance or area depending on the current_measure_state.
	match current_measure_state:
		MeasureState.RULER:
			place_line(point_1, point_2, main_line);
		MeasureState.ATK_AOE_CIRCLE:
			place_circle(point_1, point_2, main_circle);
		MeasureState.ATK_AOE_SQUARE:
			place_square(point_1, point_2, main_square);
		MeasureState.ATK_AOE_CONE:
			place_cone(point_1, point_2, main_cone, main_cone_parts);
		MeasureState.ATK_AOE_RECTANGLE:
			place_rectangle(point_1, point_2, main_rectangle, main_rectangle_parts);


func switch_point_state(state: String) -> void: ## Switch the ruler's PlaceState for placing points
	match state.to_lower():
		"place_point_1":
			current_place_state = PlaceState.PLACE_POINT_1;
		"place_point_2":
			current_place_state = PlaceState.PLACE_POINT_2;
		"idle":
			current_place_state = PlaceState.IDLE;
		_:
			print_debug("Invalid State: " + state);

func switch_aoe_state(state: String) -> void: ## Switch the ruler's AoeState for attack area
	match state.to_lower():
		"ruler":
			current_measure_state = MeasureState.RULER;
			hide_lines();
		"atk_aoe_circle":
			current_measure_state = MeasureState.ATK_AOE_CIRCLE;
			hide_lines();
		"atk_aoe_cone":
			current_measure_state = MeasureState.ATK_AOE_CONE;
			hide_lines();
		"atk_aoe_square":
			current_measure_state = MeasureState.ATK_AOE_SQUARE;
			hide_lines();
		"atk_aoe_rectangle":
			current_measure_state = MeasureState.ATK_AOE_RECTANGLE;
			hide_lines();
		_:
			print_debug("Invalid State: " + state);

func hide_lines(): ## hide all the drawn lines 
	main_line.hide();
	main_circle.hide();
	main_square.hide();
	main_cone.hide();
	main_rectangle.hide();

func place_line(p1: MeshInstance3D, p2: MeshInstance3D, given_line: MeshInstance3D) -> void: ## place a given line between two given points
	if(p1.is_visible_in_tree() && p2.is_visible_in_tree()): # show the line only if both points are visible
		given_line.show();

		# set the line to be in-between the two points
		given_line.global_position = calculate_midpoint(p1, p2);
		given_line.mesh.height = calculate_distance_between_two_points(p1, p2);
		if(p1.global_position != p2.global_position):
			given_line.look_at(p2.global_position); # line's rotation
			given_line.rotation_degrees.x += 90;
		else:
			given_line.hide();
		
		distance.text = str(round(main_line.mesh.height * 100 * RULER_DISTANCE_MULTIPLIER)/100) + "ft";
	else: # hide the line otherwise
		given_line.hide();

func place_circle(p1: MeshInstance3D, p2: MeshInstance3D, given_circle: MeshInstance3D) -> void: ## place a given circle with a radius of the distance between two given points and centered at p1.
	if(p1.is_visible_in_tree() && p2.is_visible_in_tree()): # show the circle only if both points are visible
		given_circle.show();
		
		given_circle.global_position = p1.global_position; # Set the circle to be centered at point 1
		
		# Set it's radius equal to the distance between the two points.
		given_circle.mesh.inner_radius = calculate_distance_between_two_points(p1, p2) - 0.05;
		given_circle.mesh.outer_radius = given_circle.mesh.inner_radius + 0.1;
		
		radius.text = str(round((given_circle.mesh.inner_radius+0.05) * 100 * RULER_DISTANCE_MULTIPLIER)/100) + "ft";
		
		radius.global_position = calculate_midpoint(p1, p2);
		radius.global_position.y = p1.global_position.y + 0.1;
	else:
		given_circle.hide(); # TODO: Implement hiding the circle when a button is toggled, not when the mode is switched so that users can move figures while seeing the AOE.

func place_square(p1: MeshInstance3D, p2: MeshInstance3D, given_square: MeshInstance3D) -> void: ## place a given square with a reach of the distance between two given points and centered at p1.
	if(p1.is_visible_in_tree() && p2.is_visible_in_tree()): # show the square only if both points are visible
		given_square.show();
		
		given_square.global_position = calculate_midpoint(p1, p2); # set the square to be centered between p1 and p2, with the same y position as p1
		given_square.global_position.y = p1.global_position.y;
		
		# Set it's width equal to the distance between the two points.
		given_square.mesh.inner_radius = (calculate_distance_between_two_points(p1, p2)/2 - 0.05);
		given_square.mesh.outer_radius = (given_square.mesh.inner_radius + 0.1);
		
		if(!(given_square.global_position.is_equal_approx(p2.global_position))):
			given_square.look_at(p2.global_position); # line's rotation
			given_square.rotation_degrees.x = 0;
			given_square.rotation_degrees.z = 0;
		
		var c = (given_square.mesh.inner_radius+0.05);
		var adjacent = c*cos(PI/4);
		width.text = str(round(adjacent * 2 * RULER_DISTANCE_MULTIPLIER * 100)/100) + "ft";
		
		width.global_position = calculate_midpoint(p1, p2);
		width.global_position.y = p1.global_position.y + 0.1;
	else:
		given_square.hide(); # TODO: Implement hiding the circle when a button is toggled, not when the mode is switched so that users can move figures while seeing the AOE.

func place_cone(p1: MeshInstance3D, p2: MeshInstance3D, given_cone: Node3D, cone_data: Dictionary) -> void: ## place a given cone with a reach of the distance between two given points starting at p1.
	if(p1.is_visible_in_tree() && p2.is_visible_in_tree()): # show the line only if both points are visible
		given_cone.show();
		
		var cone_size = calculate_distance_between_two_points(p1, p2);
		
		# set line2 to be the end of the cone.
		cone_data.get("cone_l2").global_position = p2.global_position;
		cone_data.get("cone_l2").global_position.y = p1.global_position.y;
		cone_data.get("cone_l2").mesh.height = cone_size;
		if(!(p1.global_position.is_equal_approx(cone_data.get("cone_l2").global_position))):
			cone_data.get("cone_l2").look_at(p1.global_position); # rotation
			cone_data.get("cone_l2").rotation_degrees.z += 90;
		else:
			main_cone.hide();
			
		# set the cone's extra points
		cone_data.get("cone_p1").global_position = p2.global_position;
		cone_data.get("cone_p2").global_position = p2.global_position;
		cone_data.get("cone_p1").global_position.y = p1.global_position.y;
		cone_data.get("cone_p2").global_position.y = p1.global_position.y;
		cone_data.get("cone_p1").position.y = (cone_data.get("cone_l2").mesh.height/2);
		cone_data.get("cone_p2").position.y = -(cone_data.get("cone_l2").mesh.height/2);
		
		# set the cone's side lines
		cone_data.get("cone_l1").mesh.height = calculate_distance_between_two_points(p1, cone_data.get("cone_p1"));
		cone_data.get("cone_l3").mesh.height = calculate_distance_between_two_points(p1, cone_data.get("cone_p2"));
		cone_data.get("cone_l1").global_position = calculate_midpoint(p1, cone_data.get("cone_p1"));
		cone_data.get("cone_l3").global_position = calculate_midpoint(p1, cone_data.get("cone_p2"));
		if(!(p1.global_position.is_equal_approx(cone_data.get("cone_l1").global_position)) && !(p1.global_position.is_equal_approx(cone_data.get("cone_l3").global_position))):
			cone_data.get("cone_l1").look_at(p1.global_position);
			cone_data.get("cone_l3").look_at(p1.global_position);
			cone_data.get("cone_l1").rotation_degrees.x += 90;
			cone_data.get("cone_l3").rotation_degrees.x += 90;
		
		size.global_position = calculate_midpoint(p1, p2);
		size.global_position.y = p1.global_position.y + 0.1;
		size.text = str(round(cone_size * RULER_DISTANCE_MULTIPLIER * 100)/100) + "ft";
	else: # hide the cone otherwise
		given_cone.hide();

func place_rectangle(p1: MeshInstance3D, p2: MeshInstance3D, given_rectangle: Node3D, rectangle_data: Dictionary) -> void: ## place a given rectangle with a reach of the distance between two given points starting at p1.
	if(p1.is_visible_in_tree() && p2.is_visible_in_tree()): # show the line only if both points are visible
		given_rectangle.show();
		
		# measurements
		var rectangle_size_long = absf(p2.global_position.x - p1.global_position.x);
		var rectangle_size_short = absf(p2.global_position.z - p1.global_position.z);
		
		# set extra points
		rectangle_data.get("rectangle_p3").global_position.x = p2.global_position.x; # top right point
		rectangle_data.get("rectangle_p3").global_position.z = p1.global_position.z;
		rectangle_data.get("rectangle_p3").global_position.y = p1.global_position.y;

		rectangle_data.get("rectangle_p4").global_position.z = p2.global_position.z; # bottom left point
		rectangle_data.get("rectangle_p4").global_position.x = p1.global_position.x;
		rectangle_data.get("rectangle_p4").global_position.y = p1.global_position.y;
		
		# set lines
		var p5 = rectangle_data.get("rectangle_p5");
		p5.global_position = Vector3(p2.global_position.x, p1.global_position.y, p2.global_position.z); # set p5 to be where p2 is but at p1's y level
		p5.hide();
		
		# long lines
		rectangle_data.get("rectangle_ll1").mesh.height = calculate_distance_between_two_points(p1, rectangle_data.get("rectangle_p3"));
		rectangle_data.get("rectangle_ll1").global_position = calculate_midpoint(p1, rectangle_data.get("rectangle_p3"));
		rectangle_data.get("rectangle_ll2").mesh.height = calculate_distance_between_two_points(rectangle_data.get("rectangle_p4"), p5);
		rectangle_data.get("rectangle_ll2").global_position = calculate_midpoint(rectangle_data.get("rectangle_p4"), p5);
		if(!(p1.global_position.is_equal_approx(rectangle_data.get("rectangle_ll1").global_position)) && !(p5.global_position.is_equal_approx(rectangle_data.get("rectangle_ll2").global_position))):
			rectangle_data.get("rectangle_ll1").look_at(p1.global_position);
			rectangle_data.get("rectangle_ll1").rotation_degrees.x += 90;
			rectangle_data.get("rectangle_ll2").look_at(p5.global_position);
			rectangle_data.get("rectangle_ll2").rotation_degrees.x += 90;
		else:
			main_rectangle.hide();
			
		# short lines
		rectangle_data.get("rectangle_ls1").mesh.height = calculate_distance_between_two_points(p1, rectangle_data.get("rectangle_p4"));
		rectangle_data.get("rectangle_ls1").global_position = calculate_midpoint(p1, rectangle_data.get("rectangle_p4"));
		rectangle_data.get("rectangle_ls2").mesh.height = calculate_distance_between_two_points(rectangle_data.get("rectangle_p3"), rectangle_data.get("rectangle_p5"));
		rectangle_data.get("rectangle_ls2").global_position = calculate_midpoint(rectangle_data.get("rectangle_p3"), p5);
		if(!(p1.global_position.is_equal_approx(rectangle_data.get("rectangle_ls1").global_position)) && !(p5.global_position.is_equal_approx(rectangle_data.get("rectangle_ls2").global_position))):
			rectangle_data.get("rectangle_ls1").look_at(p1.global_position);
			rectangle_data.get("rectangle_ls1").rotation_degrees.x += 90;
			rectangle_data.get("rectangle_ls2").look_at(p5.global_position);
			rectangle_data.get("rectangle_ls2").rotation_degrees.x += 90;
			
		else:
			main_rectangle.hide();
		
		# line measurement texts
		long_line_size.global_position = calculate_midpoint(p1, rectangle_data.get("rectangle_p3"));
		long_line_size.global_position.y = p1.global_position.y + 0.1;
		long_line_size.text = str(round(rectangle_size_long * RULER_DISTANCE_MULTIPLIER * 100)/100) + "ft";

		short_line_size.global_position = calculate_midpoint(p1, rectangle_data.get("rectangle_p4"));
		short_line_size.global_position.y = p1.global_position.y + 0.1;
		short_line_size.text = str(round(rectangle_size_short * RULER_DISTANCE_MULTIPLIER * 100)/100) + "ft";

	else: # hide the cone otherwise
		given_rectangle.hide();

func calculate_distance_between_two_points(p1: MeshInstance3D, p2: MeshInstance3D) -> float: ## returns the distance between two points(p1 & p2) in a 3D space
	# c = sqrt(x^2 + y^2 + z^2);
	return sqrt(pow(abs(p2.global_position.x - p1.global_position.x), 2) + pow(abs(p2.global_position.y - p1.global_position.y), 2) + pow(abs(p2.global_position.z - p1.global_position.z), 2));

func calculate_midpoint(p1: MeshInstance3D, p2: MeshInstance3D) -> Vector3: ## returns the point in the middle of p1 & p2 in a 3D space
	return ((p2.global_position - p1.global_position)/2) + p1.global_position;
