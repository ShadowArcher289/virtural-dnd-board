extends Control

const SWITCH_MAP_IMAGE = preload("res://scenes/user_interface/switch_map_image.tscn");

@export var main_map: CSGBox3D;

func _ready() -> void:
	SignalBus.map_uploaded.connect(_map_uploaded);
	
	for map in Globals.maps: # get every creature stored in the game
		map = Globals.maps.get(map);
		#var new_object = spawn_object.new("creature", creature.get("name"), creature.get("image_path")); # doesn't work well, the aspect ratio is not stored
		create_switch_map_button(map);


func _map_uploaded(key: String): ## add another creature to the add list when one is created
	var map = Globals.maps.get(key);
	create_switch_map_button(map);


func create_switch_map_button(map_image: Dictionary):
	var new_switch_map_to_image = SWITCH_MAP_IMAGE.instantiate();
	new_switch_map_to_image.board_map = main_map;
	new_switch_map_to_image.map_image_name = map_image.get("name");
	new_switch_map_to_image.object_image = map_image.get("image");
	self.add_child(new_switch_map_to_image);
	new_switch_map_to_image.show();
