extends Button

const FIGURE = preload("res://scenes/figure.tscn")

@export var object_type: String = "creature";
@export var object_name: String = "Thri-Kreen"; ## Name of the object
@export var object_image: Resource = load("res://assets/creatures/thri-kreen.jpg"); ## The path to the image that will display as the button.
@export var creature_stats: String = "Stats"; ## stats for a creature

#@warning_ignore("shadowed_variable")
#func _init(object_type: String, object_name: String, objejct_image_path: String, creature_stats: String = "Stats" ) -> void:
	#self.object_type = object_type;
	#self.object_name = object_name;
	#self.objejct_image_path = objejct_image_path;
	#
	## optional, object-specific parameters
	#self.creature_stats = creature_stats;
	#
	#print(object_name + " object created!");

func _ready() -> void:
	self.icon = object_image;
	print(object_type);
	print(object_name);
	print(object_image);

func _on_pressed() -> void:
	var new_object: Node3D = FIGURE.instantiate();
	new_object.position = Vector3(0, 0, 0);
	new_object.object_type = self.object_type;
	new_object.object_name = self.object_name;
	new_object.object_image = self.object_image;
	new_object.creature_stats = self.creature_stats;
	new_object.show();
	get_tree().root.add_child(new_object);
