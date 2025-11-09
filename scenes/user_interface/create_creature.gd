extends FoldableContainer

@onready var creature_name: LineEdit = $VBoxContainer/CreatureName
@onready var stats: TextEdit = $VBoxContainer/Stats
@onready var description: TextEdit = $VBoxContainer/Description
@onready var texture_rect: TextureRect = $VBoxContainer/TextureRect

@onready var file_dialog: FileDialog = $"../FileDialog"

var image_path = "res://icon.svg";

func _on_file_dialog_file_selected(path: String) -> void:
	
	var image = Image.new()
	image.load(path);
	
	image_path = path;
		
	var image_texture = ImageTexture.new();
	image_texture.set_image(image);
	
	texture_rect.texture = image_texture;

func add_image() -> void:
	file_dialog.popup();

func create_creature() -> void:
	var key = creature_name.text.to_kebab_case();
	
	Globals.creatures.get_or_add(key, {
		"name": creature_name.text, 
		"image_path": image_path, 
		"stats": stats.text,
		"description": description.text
	}); # adds the creature with the key:value creature-name, Dictionary{}
	SignalBus.creature_created.emit(key);
