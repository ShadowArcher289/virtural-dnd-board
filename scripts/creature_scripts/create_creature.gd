extends FoldableContainer

@onready var creature_name: LineEdit = $VBoxContainer/CreatureName
@onready var description: TextEdit = $VBoxContainer/Description
@onready var texture_rect: TextureRect = $VBoxContainer/TextureRect

@onready var stats: TextEdit = $VBoxContainer/Stats
@onready var str_data: TextEdit = $VBoxContainer/StatsContainer/Str/StrData
@onready var dex_data: TextEdit = $VBoxContainer/StatsContainer/Dex/DexData
@onready var con_data: TextEdit = $VBoxContainer/StatsContainer/Con/ConData
@onready var int_data: TextEdit = $VBoxContainer/StatsContainer/Int/IntData
@onready var wis_data: TextEdit = $VBoxContainer/StatsContainer/Wis/WisData
@onready var cha_data: TextEdit = $VBoxContainer/StatsContainer/Cha/ChaData


@onready var file_dialog: FileDialog = $"../FileDialog"

var image = Image.new();

func _on_file_dialog_file_selected(path: String) -> void:
	
	image = Image.new();
	image.load(path);
	
	UserResourceManager.figure_image.get_or_add(path, image);
	
	var image_texture = ImageTexture.new();
	image_texture.set_image(image);
	
	texture_rect.texture = image_texture;

func add_image() -> void:
	file_dialog.popup();

func create_creature() -> void:
	var key = creature_name.text.to_kebab_case();
	
	Globals.creatures.get_or_add(key, {
		"name": creature_name.text, 
		"image": image, 
		"stats": format_stats(), # TODO: Change this to be a dictionary of the stats
		"description": description.text
	}); # adds the creature with the key:value creature-name, Dictionary{}
	SignalBus.creature_created.emit(key);

func format_stats() -> Dictionary: ## return the stats in the form of a dictionary
	return {"ability_scores": [int(str_data.text), int(dex_data.text), int(con_data.text), int(int_data.text), int(wis_data.text), int(cha_data.text)], "proficiencies": stats.text}; # default
