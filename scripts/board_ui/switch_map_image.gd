extends Button


@export var map: CSGBox3D; ## the map to edit
@export var map_image_name: String = "forest"; ## the key to access the map image

var object_image = Globals.maps.get(map_image_name.to_lower()).get("image");


func _ready() -> void:
	if(not object_image is CompressedTexture2D): # if the image is not a Texture (meaning it is likely a user's image), then set it as a texture
		var image_texture = ImageTexture.new();
		image_texture.set_image(object_image);
		self.icon = image_texture;
	else: # otherwise, the image is likely a pre-added image so just use it
		self.icon = object_image;
		
func switch_map() -> void: ## Switch the combat board's map to a specified map.
	if(object_image != null):
		if(not object_image is CompressedTexture2D): # if the image is not a Texture (meaning it is likely a user's image), then set it as a texture
			var image_texture = ImageTexture.new();
			image_texture.set_image(object_image);
			map.material_override.albedo_texture = image_texture;
		else:
			map.material_override.albedo_texture = object_image;
	else:
		print_debug("Invalid map image name.");
