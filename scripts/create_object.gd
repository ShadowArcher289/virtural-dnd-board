extends FoldableContainer

@onready var object_name: LineEdit = $VBoxContainer/ObjectName
@onready var texture_rect: TextureRect = $VBoxContainer/TextureRect

@onready var file_dialog_3d: FileDialog = $"../FileDialog_3d"

# Like with create_creature.gd, the user will input a file and the program will add it to the add.tscn scene's options of things to add to the board. 
# 	When given a png(or any image type), will just add a png(or the other respective image type)
# 	When given a 3d model file, will add the 3d model. 

var model = Image.new();

func _on_file_dialog_3d_file_selected(path: String) -> void:
	pass # Replace with function body.
	#
	#image = Image.new();
	#image.load(path);
	#
	#UserResourceManager.figure_image.get_or_add(path, image);
	#
	#var image_texture = ImageTexture.new();
	#image_texture.set_image(image);
	#
	#texture_rect.texture = image_texture;

func _on_add_model_pressed() -> void:
	file_dialog_3d.popup();


func create_object() -> void:
	pass # Replace with function body.
	#var key = creature_name.text.to_kebab_case();
	#
	#Globals.creatures.get_or_add(key, 
		#FigureData.new(
			#creature_name.text, 
			#image, 
			#format_stats(), # TODO: Change this to be a dictionary of the stats
			#description.text
		#)
	#); # adds the creature with the key:value creature-name, FigureData{}
	#SignalBus.object_created.emit(key);
