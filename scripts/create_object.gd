extends FoldableContainer

@onready var object_name: LineEdit = $VBoxContainer/ObjectName
@onready var collidable: CheckBox = $VBoxContainer/Collidable
@onready var description: TextEdit = $VBoxContainer/Description
@onready var path_label: Label = $VBoxContainer/PathLabel

@onready var file_dialog_3d: FileDialog = $"../FileDialog_3d"

# Like with create_creature.gd, the user will input a file and the program will add it to the add.tscn scene's options of things to add to the board. 
# 	When given a png(or any image type), will just add a png(or the other respective image type)
# 	When given a 3d model file, will add the 3d model. 

var gltf_document = GLTFDocument.new();
var gltf_state = GLTFState.new(); 
var is_collidable : bool = false; ## if true, then the object will be a collider for the mouse pointer

func _on_file_dialog_3d_file_selected(path: String) -> void: ## when an appropriate file is selected, processes that file into something the game can use for 3D models.
	
	path_label.text = path;
	
	gltf_document = GLTFDocument.new();
	gltf_state = GLTFState.new(); 
	
	var error = gltf_document.append_from_file(path, gltf_state);

	if(error != OK):
		print_debug("Couldn't load glTF scene: " + error_string(error));

func _on_add_model_pressed() -> void:
	file_dialog_3d.popup();


func create_object() -> void: ## adds the object to the Globals.objects dictionary and emits the object_created signal.
	var key = object_name.text.to_kebab_case();
	
	is_collidable = collidable.button_pressed; # is_collidable = true if the collidable button is pressed
	
	Globals.objects.get_or_add(key, ObjectData.new(
		object_name.text, 
		gltf_document, 
		gltf_state, 
		null,
		is_collidable,
		description.text
	)
	); # adds the object with the key:value object-name, model
	SignalBus.object_created.emit(key);
	
	clear_inputs();

func clear_inputs() -> void: ## clears the inputs upon creation so the user knows the creation worked.
	object_name.text = "";
	is_collidable = false;
	description.text = "";
	path_label.text = "*path*";
