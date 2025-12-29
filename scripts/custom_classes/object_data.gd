## The data for an Object.
## Contains: name, gltf_document, gltf_state, is_collidable
extends Resource
class_name ObjectData

@export var name : String; ## the object's name
@export var gltf_document : GLTFDocument ## the object's gltf_document (holds some visual data)
@export var gltf_state : GLTFState ## the object's gltf_state (holds some visual data)
@export var model : Resource = null; ## if the object is already imported into the project (like for testing or as default options), then you can use the model_path instead.
@export var is_collidable : bool; ## if the object triggers collisions or not

func _init(f_name: String, f_gltf_document: GLTFDocument, f_gltf_state: GLTFState, f_model : Resource = null, f_is_collidable: bool = false) -> void:
	self.name = f_name;
	self.gltf_document = f_gltf_document;
	self.gltf_state = f_gltf_state;
	self.model = f_model;
	self.is_collidable = f_is_collidable;

func _to_string() -> String:
	return "name: [" + name + "] gltf_document: [" + str(gltf_document) + "] gltf_state: [" + str(gltf_state) + "] model: [" + str(model) + "] is_collidable: [" + str(is_collidable) + "]";
