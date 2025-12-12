extends VBoxContainer

const SPAWN_OBJECT_ON_BOARD = preload("res://scenes/user_interface/spawn_object_on_board.tscn");

var object_spawners: Array = []; ## stores all the opject spawners

func _ready() -> void:
	SignalBus.creature_created.connect(_creature_created);
	
	for creature in Globals.creatures: # get every creature stored in the game
		creature = Globals.creatures.get(creature);
		#var new_object = spawn_object.new("creature", creature.get("name"), creature.get("image_path")); # doesn't work well, the aspect ratio is not stored
		create_object_spawner(creature);

func _creature_created(key: String): ## add another creature to the add list when one is created
	var creature = Globals.creatures.get(key);
	create_object_spawner(creature);


func create_object_spawner(creature: Dictionary):
	print(creature);
	var new_object_spawner = SPAWN_OBJECT_ON_BOARD.instantiate();
	new_object_spawner.object_type = "creature";
	new_object_spawner.object_name = creature.get("name");
	new_object_spawner.object_image = creature.get("image");
	new_object_spawner.object_description = creature.get("description");
	new_object_spawner.creature_stats = creature.get("stats");
	self.add_child(new_object_spawner);
	object_spawners.append(new_object_spawner);
	new_object_spawner.show();


func _on_line_edit_text_changed(new_text: String) -> void: # show/hide object_spawners when the line_edit search field is edited
	for object_spawner in object_spawners:
		if(new_text == ""): # when the text is empty, show all
			object_spawner.show();
		elif(object_spawner.object_name.to_lower().contains(new_text.to_lower())):
			object_spawner.show();
		else:
			object_spawner.hide();
