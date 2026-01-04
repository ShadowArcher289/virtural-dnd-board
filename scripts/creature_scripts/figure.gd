class_name Figure extends Node3D

## A unique figure to be used on the board. Each figure holds all the data for it's respective instance of a creature
## object_name, object_image_path, creature_stats
 
@onready var image: MeshInstance3D = $Image
@onready var base: CSGMesh3D = $Base
@onready var figure_name: Label3D = $FigureName

@onready var conditions: Node3D = $Conditions ## stores objects to identify conditions on a creature
@onready var red_ring: MeshInstance3D = $Conditions/RedRing
@onready var orange_ring: MeshInstance3D = $Conditions/OrangeRing
@onready var yellow_ring: MeshInstance3D = $Conditions/YellowRing
@onready var green_ring: MeshInstance3D = $Conditions/GreenRing
@onready var blue_ring: MeshInstance3D = $Conditions/BlueRing
@onready var purple_ring: MeshInstance3D = $Conditions/PurpleRing
@onready var pink_ring: MeshInstance3D = $Conditions/PinkRing
@onready var white_ring: MeshInstance3D = $Conditions/WhiteRing


@export var object_type: String = "creature";
@export var object_data: Resource = FigureData.new(
	"Thri-Kreen", load("res://assets/creatures/thri-kreen.jpg"), 
	{"ability_scores": [12, 13, 4, 5, 12, 53], "max_hp": 40}, 
	"Cool ant person"
);
#@export var creature_conditions: Array[String] = ["poisoned", "on_fire"]; ## A list of conditions on the creature (ex: poisoned, damaged, petrified)

# colors
const GREEN = "#00c600";
const LIGHT_GREEN = "#79ed5f";
const YELLOW = "#ffdc17";
const ORANGE = "#ff8f17";
const RED = "#ff3217";
const BLACK = "#000000";
const INFO_COLOR = "#57d5ff";

enum State { ## The types of states for a Figure
	STILL,
	PICKED,
	INFO
}

@export var max_hp: float = 0;
@export var current_hp: float = 0;

var new_material = StandardMaterial3D.new();

var current_state = State.STILL; ## The current state of the creature, the default state is STILL.

var mouse_position: Vector2; ## The current mouse position.
var current_position = self.position;

var released = true; ## holds if the figure has been released (ie. the mouse is still held down after clicking).


func _ready() -> void:
	match object_type:
		"creature":
			if(not object_data is FigureData): # confirm object_data is of the FigureData type
				push_error("Error: object_data is not of type ObjectData | " + type_string(typeof(object_data)));
			
			if(object_data.get("stats").get("max_hp") == null): # account for max_hp being null
				max_hp = 0;
			else:
				if(max_hp == 0.0): # only set hp values if they have not been previously set.
					max_hp = object_data.get("stats").get("max_hp");
			if(current_hp == 0.0):
				current_hp = max_hp;
				
			var new_material = StandardMaterial3D.new();
			
			if(not object_data.image is CompressedTexture2D): # if the image is not a Texture (meaning it is likely a user's image), then set it as a texture
				var image_texture = ImageTexture.new();
				image_texture.set_image(object_data.image);
				new_material.albedo_texture = image_texture;
			else: # otherwise, the image is likely a pre-added image so just use it
				new_material.albedo_texture = object_data.image;
			
			new_material.billboard_mode = BaseMaterial3D.BILLBOARD_FIXED_Y;
			new_material.billboard_keep_scale = true;
			
			image.material_override = new_material;
			figure_name.text = object_data.name;
			#
		#"object":
			#if(not object_data is ObjectData): # confirm object_data is of the ObjectData type
				#push_error("Error: object_data is not of type ObjectData | " + type_string(typeof(object_data)));
			#
			#if(object_data.model != null): # add pre-loaded 3D models
				#if(object_data.is_collidable):
					#add_collision_to_scene(object_data.model);
				#self.add_child(object_data.model);
			#else: # add user-added 3D models
				#var scene = object_data.gltf_document.generate_scene(object_data.gltf_state); # Generate the scene from the document
				#scene.transform.origin = Vector3(0, 0, 0);
				#if(object_data.is_collidable):
					#add_collision_to_scene(scene);
				#self.add_child(scene); # Add the newly loaded scene to the current scene tree as a child of this figure
			#print_debug("3D model loaded");
		#_:
			#print_debug("Error: Invalid object_type");

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("left_click")):
		if(current_state == State.INFO):
			switch_state(State.STILL);
			MouseCollision.remove_selected_creature();
	if(event.is_action_released("left_click")):
		released = true;
		if(current_state != State.INFO):
			switch_state(State.STILL);
			MouseCollision.remove_selected_creature();

func _process(_delta: float) -> void:
	match current_state:
		State.STILL:
			if(max_hp == 0): # change the base color depending on the hp, green if there is no specified max_hp
				new_material.albedo_color = GREEN;
			else:
				
				var hp_percentage = (current_hp/max_hp);
				
				if(hp_percentage >= 1.0):
					new_material.albedo_color = GREEN;
				elif(hp_percentage > 0.45):
					new_material.albedo_color = LIGHT_GREEN;
				elif(hp_percentage > 0.25):
					new_material.albedo_color = ORANGE;
				elif(hp_percentage > 0.0):
					new_material.albedo_color = RED;
				elif(hp_percentage == 0.0):
					new_material.albedo_color = BLACK;
				
			base.material_override = new_material
		State.PICKED:
			if MouseCollision.mouse_raycast_data != null && MouseCollision.mouse_raycast_data.get("position") != null:
				self.global_position = Vector3(MouseCollision.mouse_raycast_data.get("position").x, MouseCollision.mouse_raycast_data.get("position").y - base.mesh.size.y, MouseCollision.mouse_raycast_data.get("position").z);
			
			new_material.albedo_color = YELLOW;
			base.material_override = new_material;
		State.INFO:
			new_material.albedo_color = INFO_COLOR;
			base.material_override = new_material;
		_:
			print_debug("Error: Invalid State ()" + str(current_state) + ") for Figure");
	
	if(object_data.status_rings.get("red") == true): ## hide or show the respective condition rings
		show_condition_ring("red");
	else:
		hide_condition_ring("red");
	if(object_data.status_rings.get("orange") == true):
		show_condition_ring("orange");
	else:
		hide_condition_ring("orange");
	if(object_data.status_rings.get("yellow") == true):
		show_condition_ring("yellow");
	else:
		hide_condition_ring("yellow");
	if(object_data.status_rings.get("green") == true):
		show_condition_ring("green");
	else:
		hide_condition_ring("green");
	if(object_data.status_rings.get("blue") == true):
		show_condition_ring("blue");
	else:
		hide_condition_ring("blue");
	if(object_data.status_rings.get("purple") == true):
		show_condition_ring("purple");
	else:
		hide_condition_ring("purple");
	if(object_data.status_rings.get("pink") == true):
		show_condition_ring("pink");
	else:
		hide_condition_ring("pink");
	if(object_data.status_rings.get("white") == true):
		show_condition_ring("white");
	else:
		hide_condition_ring("white");
	

func switch_state(state: State): ## Switch state and set the Global's current selected creature to this one if picked.
	current_state = state;
	#print_debug("SWITCHED STATE: " + str(state));
	if(state == State.PICKED || state == State.INFO): # switch the current selected creature
		set_current_selected_creature();

func set_current_selected_creature() -> void: ## set the MouseCollision.current_selected_creature to this figure
	var self_as_creature_dictionary = {}
	self_as_creature_dictionary = { ## This figure, but as a creature dictionary.
		"data": object_data, ## the object's data
		"type": object_type,
		"object": self
	}
	SignalBus.creature_selected.emit(self_as_creature_dictionary);
	MouseCollision.current_selected_creature = self_as_creature_dictionary;

func click(): ## function called when the object is clicked by the user in the 3D view
	if current_state != State.STILL && released:
		switch_state(State.STILL);
	else: # switch to the repsective state based on the MouseCollision's state.
		if(MouseCollision.current_selected_creature.size() == 0): # run if there is no selected creature
			if(MouseCollision.currentState("info")):
				switch_state(State.INFO);
				released = false;
			elif(MouseCollision.currentState("select")):
				switch_state(State.PICKED);
				released = false;
	#print_debug("I HAVE BEEN CLICKED");

func show_condition_ring(ring_color: String): ## show a given colored ring. 
	match ring_color:
		"red":
			red_ring.show();
		"orange":
			orange_ring.show();
		"yellow":
			yellow_ring.show();
		"green":
			green_ring.show();
		"blue":
			blue_ring.show();
		"purple":
			purple_ring.show();
		"pink":
			pink_ring.show();
		"white":
			white_ring.show();
		_:
			print_debug("Error: Invalid color for show_condition_ring()");

func hide_condition_ring(ring_color: String): ## hide a given colored ring. 
	match ring_color:
		"red":
			red_ring.hide();
		"orange":
			orange_ring.hide();
		"yellow":
			yellow_ring.hide();
		"green":
			green_ring.hide();
		"blue":
			blue_ring.hide();
		"purple":
			purple_ring.hide();
		"pink":
			pink_ring.hide();
		"white":
			white_ring.hide();
		_:
			print_debug("Error: Invalid color for show_condition_ring()");

# ||| Functions for 3D Models |||


func add_collision_to_scene(scene: Node3D): ## add collisions to the scene
# ||| generates a lot of meshes to have collisions |||
	var meshes = find_mesh_instances(scene)

	for mesh in meshes:
		if mesh.mesh:
			var body := StaticBody3D.new()
			mesh.get_parent().add_child(body)
			
			var col := CollisionShape3D.new()
			col.shape = mesh.mesh.create_trimesh_shape()
			body.add_child(col)
			
			# Match transform so the collision aligns with the mesh
			body.transform = mesh.transform

func find_mesh_instances(node: Node) -> Array: ## finds all MeshInstance3D children(both direct and indirect) in a given node
	var meshes: Array = []
	for child in node.get_children():
		if child is MeshInstance3D:
			meshes.append(child)
		meshes.append_array(find_mesh_instances(child))
	return meshes
