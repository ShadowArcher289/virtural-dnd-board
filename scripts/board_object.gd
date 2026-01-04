class_name BoardObject extends Node3D

## A unique object to be used on the board. Each object holds all the data for it's respective instance of an object
## object_data(the model path), is_colliding
 
@onready var base: CSGMesh3D = $Base

@export var object_type: String = "object";
@export var object_data: Resource = ObjectData.new("Wooden Chest", null, null, load("res://assets/3d_models/default_models/wooden_chest.glb"), false, "a wooden chest made of wood");

var origin_is_in_center = true; ## true if the origin is in the true-center of the object, (false) assumes the origin is the center-bottom of the object

@export var model_modified_position: Vector3 = Vector3(0, 0, 0); ## x, y, z, modified position for if the user modified the 3d model's position. used when loading the object using the save/load system to save the object's location change.
@export var model_modified_scale: Vector3 = Vector3(0, 0, 0); ## modified position for if the user modified the 3d model's scale. used when loading the object using the save/load system to save the object's scale change.
@export var is_moveable: bool = true; ## if false, then the object will not move in the PICKED state;

enum State { ## The types of states for a Figure
	STILL,
	PICKED,
	INFO
}

var new_mesh = BoxMesh.new();
var new_material = StandardMaterial3D.new();

var current_state = State.STILL; ## The current state of the object, the default state is STILL.

var mouse_position: Vector2; ## The current mouse position.
var current_position = self.position;

var released = true; ## holds if the object has been released (ie. the mouse is still held down after clicking).

func _ready() -> void:
	
	if(not object_data is ObjectData): # confirm object_data is of the ObjectData type
		push_error("Error: object_data is not of type ObjectData | " + type_string(typeof(object_data)));

	if(object_data.model != null): # add pre-loaded 3D models
		if(object_data.is_collidable):
			add_collision_to_scene(object_data.model);
			
		var model = object_data.model.instantiate();
		self.add_child(model);

		
		# UNUSED Because models aren't made consistently and omg it's so annoying when people just don't make models the same way AHHHHHHHH :(
		#var meshes = find_mesh_instances(model); # align the model so the base mesh is on the bottom
		#if(origin_is_in_center):
			#model.transform.origin.y = (meshes[0].get_aabb().size.y/2); # move models's origin to be half of the 1st mesh
			
		#new_mesh.size.x = meshes[0].get_aabb().size.x*0.80;
		#new_mesh.size.y = meshes[0].get_aabb().size.y*0.4;
		#new_mesh.size.z = meshes[0].get_aabb().size.z*0.9;
		#base.mesh = new_mesh;
		#base.transform.origin.y += ((meshes[0].get_aabb().size.y*0.4)/2);
		
		if(model_modified_position != Vector3(0, 0, 0)): # keep model position when loading from a previously saved board
			model.position = model_modified_position;
		if(model_modified_scale != Vector3(0, 0, 0)): # keep model scale when loading from a previously saved board
			model.scale = model_modified_scale;
			
	else: # add user-added 3D models
		var scene = object_data.gltf_document.generate_scene(object_data.gltf_state); # Generate the scene from the document
		
		
		print("scene: " + str(scene));
		print("object_data.gltf_document: " + str(object_data.gltf_document));
		print("object_data.gltf_state: " + str(object_data.gltf_state));

		var meshes = find_mesh_instances(scene); # align the model so the base mesh is on the bottom
		self.add_child(scene); # Add the newly loaded scene to the current scene tree as a child of this figure

		print("Meshes: " + str(meshes))
		
		# UNUSED Because models aren't made consistently and omg it's so annoying when people just don't make models the same way AHHHHHHHH :(
		#if(origin_is_in_center):
			#scene.transform.origin.y = (meshes[0].get_aabb().size.y/2); # move models's origin to be half of the 1st mesh
#
		#new_mesh.size.x = meshes[0].get_aabb().size.x*0.80;
		#new_mesh.size.y = meshes[0].get_aabb().size.y*0.4;
		#new_mesh.size.z = meshes[0].get_aabb().size.z*0.9;
		#base.mesh = new_mesh;
		#base.transform.origin.y += ((meshes[0].get_aabb().size.y*0.4)/2);
		
		print_debug(str(scene))
		if(object_data.is_collidable):
			add_collision_to_scene(scene);
		
		if(model_modified_position != Vector3(0, 0, 0)): # keep model position when loading from a previously saved board
			scene.position = model_modified_position;
		if(model_modified_scale != Vector3(0, 0, 0)): # keep model scale when loading from a previously saved board
			scene.scale = model_modified_scale;

	print_debug("3D model loaded");



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
			new_material.albedo_color = "#00c600";
			base.material_override = new_material
		State.PICKED:
			if(is_moveable):
				if MouseCollision.mouse_raycast_data != null && MouseCollision.mouse_raycast_data.get("position") != null:
					self.global_position = Vector3(MouseCollision.mouse_raycast_data.get("position").x, MouseCollision.mouse_raycast_data.get("position").y - base.mesh.size.y , MouseCollision.mouse_raycast_data.get("position").z);
				
			new_material.albedo_color = "#ffdc17";
			base.material_override = new_material;
		State.INFO:
			new_material.albedo_color = "#57d5ff";
			base.material_override = new_material;
		_:
			print_debug("Error: Invalid State ()" + str(current_state) + ") for BoardObject");
	
	

func switch_state(state: State): ## Switch state and set the Global's current selected creature to this one if picked.
	current_state = state;
	
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
		if (child is MeshInstance3D):
			meshes.append(child)
		elif (child is ImporterMeshInstance3D):
			var converted := convert_importer_mesh(child)
			child.replace_by(converted)
			child.queue_free()
			meshes.append(converted)

		meshes.append_array(find_mesh_instances(child))
	return meshes

func convert_importer_mesh(importer: ImporterMeshInstance3D) -> MeshInstance3D: ## converts an ImporterMeshInstance3D to a MeshInstance3D
	var mesh_instance := MeshInstance3D.new()
	
	var importer_mesh: ImporterMesh = importer.mesh
	var array_mesh := importer_mesh_to_array_mesh(importer_mesh)
	mesh_instance.mesh = array_mesh
	
	# Copy transform
	mesh_instance.transform = importer.transform
	
	# Copy materials from the importer mesh
	var surface_count := importer_mesh.get_surface_count()
	for i in surface_count:
		var mat := importer_mesh.get_surface_material(i)
		if mat:
			mesh_instance.set_surface_override_material(i, mat)
	
	return mesh_instance

func importer_mesh_to_array_mesh(importer_mesh: ImporterMesh) -> ArrayMesh: ## converts and ImporterMesh to an ArrayMesh
	var array_mesh := ArrayMesh.new()
	var surface_count := importer_mesh.get_surface_count()
	
	for i in surface_count: # iterates for every surface and creates the array_mesh from data of the surfaces
		var arrays = importer_mesh.get_surface_arrays(i)
		var primitive = importer_mesh.get_surface_primitive_type(i)
		array_mesh.add_surface_from_arrays(primitive, arrays)
		
	return array_mesh
