class_name Figure extends Node3D

## A unique figure to be used on the board. Each figure holds all the data for it's respective instance of a creature
## object_name, object_image_path, creature_stats
 
@onready var image: MeshInstance3D = $Image
@onready var base: CSGMesh3D = $Base
@onready var figure_name: Label3D = $FigureName


@export var object_type: String = "creature";
@export var object_name: String = "Thri-Kreen";
@export var object_image_path: String = "res://assets/creatures/thri-kreen.jpg";
@export var creature_stats: String = "Stats";


enum State { ## The types of states for a Figure
	STILL,
	PICKED
}

var new_material = StandardMaterial3D.new();

var current_state = State.STILL; ## The current state of the creature, the default state is STILL

var mouse_position: Vector2; ## the current mouse position
var current_position = self.position;

func _ready() -> void:
	var new_material = StandardMaterial3D.new();
	new_material.albedo_texture = load(object_image_path);
	image.material_override = new_material;
	figure_name.text = object_name;

func _process(_delta: float) -> void:
	match current_state:
		State.STILL:
			new_material.albedo_color = "#00c600"
			base.material_override = new_material
		State.PICKED:
			if Globals.mouse_raycast_data != null && Globals.mouse_raycast_data.get("position") != null:
				self.global_position = Vector3(Globals.mouse_raycast_data.get("position").x, self.position.y, Globals.mouse_raycast_data.get("position").z);
				
				#if (current_position != Globals.mouse_raycast_data.get("position")): # once moved, switch state to still
					#switch_state(State.STILL);
			new_material.albedo_color = "#ffdc17"
			base.material_override = new_material
		_:
			print_debug("Error: Invalid State ()" + str(current_state) + ") for Figure");

func switch_state(state: State):
	current_state = state;

func click(): ## function called when the object is clicked by the user in the 3D view
	print_debug("SWITCHED STATE")
	if current_state == State.PICKED:
		switch_state(State.STILL);
	else:
		switch_state(State.PICKED)
	print_debug("I HAVE BEEN CLICKED")
