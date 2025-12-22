extends Button

const FIGURE = preload("res://scenes/figure.tscn")
@onready var rich_text_label: RichTextLabel = $RichTextLabel

@export var object_type: String = "creature";
@export var object_data: FigureData = FigureData.new("Thri-Kreen", load("res://assets/creatures/thri-kreen.jpg"), {"ability_scores": [12, 13, 4, 5, 12, 53]}, "Cool ant person");
#@export var object_name: String = "Thri-Kreen"; ## Name of the object.
#@export var object_image: Resource = load("res://assets/creatures/thri-kreen.jpg"); ## The path to the image that will display as the button.
#@export var object_description: String = "Cool ant person"; ## Description of the object.
#@export var creature_stats: Dictionary = {"ability_scores": [12, 13, 4, 5, 12, 53]}; ## Stats for a creature.
#@export var creature_status_rings: Dictionary = {"red": false, "orange": false, "yellow": false, "green": false, "blue": false, "purple": false, "pink": false, "white": false}

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
	if(not object_data.image is CompressedTexture2D): # if the image is not a Texture (meaning it is likely a user's image), then set it as a texture
		var image_texture = ImageTexture.new();
		image_texture.set_image(object_data.image);
		self.icon = image_texture;
	else: # otherwise, the image is likely a pre-added image so just use it
		self.icon = object_data.image;
	rich_text_label.text = self.object_data.name;
	print(object_type);
	print(object_data.name);
	print(object_data.image);

func _on_pressed() -> void:
	var new_object: Node3D = FIGURE.instantiate();
	new_object.position = Vector3(0, 0, 0);
	new_object.object_type = self.object_type;
	new_object.object_data = self.object_data;
	#new_object.object_name = self.object_name;
	#new_object.object_image = self.object_image;
	#new_object.object_description = self.object_description;
	#new_object.creature_stats = self.creature_stats;
	new_object.show();
	get_tree().root.add_child(new_object);
