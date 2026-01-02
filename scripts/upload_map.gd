extends FoldableContainer

const DEFAULT_ICON = preload("res://icon.svg");

@onready var map_name: LineEdit = $VBoxContainer/MapName
@onready var texture_rect: TextureRect = $VBoxContainer/TextureRect

@onready var map_file_dialog: FileDialog = $"../MapFileDialog"

var image = Image.new();

func _on_map_file_dialog_file_selected(path: String) -> void:
	
	image = Image.new();
	image.load(path);
	
	UserResourceManager.map_image.get_or_add(path, image);
	
	var image_texture = ImageTexture.new();
	image_texture.set_image(image);
	
	texture_rect.texture = image_texture;

func create_map() -> void:
	var key = map_name.text.to_snake_case();
	
	print("MAPS BEING CREATED")
	Globals.maps.get_or_add(key, {
		"name": map_name.text, 
		"image": image, 
	}); # adds the creature with the key:value creature-name, Dictionary{}
	SignalBus.map_uploaded.emit(key);
	
	clear_inputs();

func _on_add_map_image_pressed() -> void:
	map_file_dialog.popup();


func clear_inputs() -> void: ## clears the inputs upon creation so the user knows the creation worked.
	map_name.text = "";
	texture_rect.texture = DEFAULT_ICON;
	image = DEFAULT_ICON;
