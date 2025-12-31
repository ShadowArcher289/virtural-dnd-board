extends Button

@onready var rich_text_label: RichTextLabel = $RichTextLabel

@export var board_map: CSGBox3D; ## the map to edit
@export var map_image_name: String = "Forest"; ## the key to access the map image

@export var object_image: Resource = load("res://assets/board_maps/ForestEncampment_digital_day_grid.jpg");


func _ready() -> void:
	if(not object_image is CompressedTexture2D): # if the image is not a Texture (meaning it is likely a user's image), then set it as a texture
		var image_texture = ImageTexture.new();
		image_texture.set_image(object_image);
		self.icon = image_texture;
	else: # otherwise, the image is likely a pre-added image so just use it
		self.icon = object_image;
	rich_text_label.text = map_image_name;
		
func switch_map() -> void: ## Switch the combat board's map to a specified map.
	if(object_image != null && board_map != null):
		if(not object_image is CompressedTexture2D): # if the image is not a Texture (meaning it is likely a user's image), then set it as a texture
			var image_texture = ImageTexture.new();
			image_texture.set_image(object_image);
			board_map.material_override.albedo_texture = image_texture;
		else:
			board_map.material_override.albedo_texture = object_image;
		Globals.current_map = map_image_name.to_snake_case();
	else:
		print_debug("Invalid map image name. or [map] is null | " + str(object_image) + " | " + str(board_map) + " |");
