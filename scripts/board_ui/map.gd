extends Control

@onready var board_map: CSGBox3D = $Map ## the map to edit
@onready var map_toggle: CheckButton = $MapSwitcher/MapToggle

func _ready() -> void:
	SignalBus.board_loaded.connect(_board_loaded);
	SignalBus.switch_map.connect(_switch_map);
	
	map_toggle.focus_mode = Control.FOCUS_NONE;
	
	if(board_map.is_visible_in_tree()):
		map_toggle.button_pressed = true;
	else:
		map_toggle.button_pressed = false;

func _board_loaded() -> void:
	_switch_map(Globals.current_map);

func _switch_map(map_key: String) -> void: ## when recieving a signal to switch the map, use the given key to switch to that map.
	var object_image = Globals.maps.get(map_key).get("image");

	if(object_image != null && board_map != null):
		if(not object_image is CompressedTexture2D): # if the image is not a Texture (meaning it is likely a user's image), then set it as a texture
			var image_texture = ImageTexture.new();
			image_texture.set_image(object_image);
			board_map.material_override.albedo_texture = image_texture;
		else:
			board_map.material_override.albedo_texture = object_image;
	else:
		print_debug("Invalid map image name. or [map] is null | " + str(object_image) + " | " + str(board_map) + " |");


func _on_map_toggle_toggled(toggled_on: bool) -> void:
	if(board_map != null):
		if(!toggled_on):
			board_map.hide(); # hide the map;
		else:
			board_map.show(); # show the map;
