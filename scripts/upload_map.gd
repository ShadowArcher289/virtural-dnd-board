extends FoldableContainer

@onready var map_name: LineEdit = $VBoxContainer/MapName
@onready var texture_rect: TextureRect = $VBoxContainer/TextureRect

@onready var file_dialog: FileDialog = $"../FileDialog"

var image = Image.new();

func _on_map_file_dialog_file_selected(path: String) -> void:
	
	image = Image.new();
	image.load(path);
	
	UserResourceManager.figure_image.get_or_add(path, image);
	
	var image_texture = ImageTexture.new();
	image_texture.set_image(image);
	
	texture_rect.texture = image_texture;

func create_map() -> void:
	var key = map_name.text.to_kebab_case();
	
	Globals.maps.get_or_add(key, {
		"name": map_name.text, 
		"image": image, 
	}); # adds the creature with the key:value creature-name, Dictionary{}
	SignalBus.creature_created.emit(key);


func _on_add_map_image_pressed() -> void:
	file_dialog.popup();
