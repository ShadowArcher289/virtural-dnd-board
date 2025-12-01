class_name Figure extends Node3D

## A unique figure to be used on the board. Each figure holds all the data for it's respective instance of a creature
## object_name, object_image_path, creature_stats
 
@onready var image: MeshInstance3D = $Image
@onready var base: CSGMesh3D = $Base
@onready var figure_name: Label3D = $FigureName


@export var object_type: String = "creature";
@export var object_name: String = "Thri-Kreen";
@export var object_image: Resource = load("res://assets/creatures/thri-kreen.jpg");
@export var object_description: String = "Cool ant person";
@export var creature_stats: String = "Stats";


enum State { ## The types of states for a Figure
	STILL,
	PICKED,
	INFO
}

var new_material = StandardMaterial3D.new();

var current_state = State.STILL; ## The current state of the creature, the default state is STILL.

var mouse_position: Vector2; ## The current mouse position.
var current_position = self.position;

var released = true; ## holds if the figure has been released (ie. the mouse is still held down after clicking).

func _ready() -> void:
	
	var new_material = StandardMaterial3D.new();
	
	if(not object_image is CompressedTexture2D): # if the image is not a Texture (meaning it is likely a user's image), then set it as a texture
		var image_texture = ImageTexture.new();
		image_texture.set_image(object_image);
		new_material.albedo_texture = image_texture;
	else: # otherwise, the image is likely a pre-added image so just use it
		new_material.albedo_texture = object_image;
	
	new_material.billboard_mode = BaseMaterial3D.BILLBOARD_FIXED_Y;
	new_material.billboard_keep_scale = true;
	
	image.material_override = new_material;
	figure_name.text = object_name;

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("left_click")):
		if(current_state == State.INFO):
			switch_state(State.STILL);
			MouseCollision.remove_selected_creature();
	if(event.is_action_released("left_click")):
		print_debug("Figure Released")
		released = true;
		if(current_state != State.INFO):
			switch_state(State.STILL);
			MouseCollision.remove_selected_creature();

func _process(_delta: float) -> void:
	match current_state:
		State.STILL:
			new_material.albedo_color = "#00c600"
			base.material_override = new_material
		State.PICKED:
			if MouseCollision.mouse_raycast_data != null && MouseCollision.mouse_raycast_data.get("position") != null:
				self.global_position = Vector3(MouseCollision.mouse_raycast_data.get("position").x, self.position.y, MouseCollision.mouse_raycast_data.get("position").z);
				
				#if (current_position != MouseCollision.mouse_raycast_data.get("position")): # once moved, switch state to still
					#switch_state(State.STILL);
			new_material.albedo_color = "#ffdc17";
			base.material_override = new_material;
		State.INFO:
			new_material.albedo_color = "#57d5ff";
			base.material_override = new_material;
		_:
			print_debug("Error: Invalid State ()" + str(current_state) + ") for Figure");

func switch_state(state: State): ## Switch state and set the Global's current selected creature to this one if picked.
	current_state = state;
	print_debug("SWITCHED STATE: " + str(state));
	if(state == State.PICKED || state == State.INFO): # switch the current selected creature
		set_current_selected_creature();

func set_current_selected_creature() -> void: ## set the MouseCollision.current_selected_creature to this figure
	var self_as_creature_dictionary = {}
	self_as_creature_dictionary = { ## This figure, but as a creature dictionary.
		"name": object_name,
		"image": object_image, 
		"stats": creature_stats,
		"description": object_description,
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
	print_debug("I HAVE BEEN CLICKED");
