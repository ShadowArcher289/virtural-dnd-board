extends VBoxContainer

const SPAWN_OBJECT_ON_BOARD = preload("res://scenes/user_interface/spawn_object_on_board.tscn");

var object_spawners: Array = []; ## stores all the opject spawners

func _ready() -> void:
	SignalBus.creature_created.connect(_creature_created);
	SignalBus.object_created.connect(_object_created);
	SignalBus.board_loaded.connect(_generate_spawners);
	
	_generate_spawners();

func _generate_spawners() -> void: ## generate spawners from the objects in Globals
	for creature in Globals.creatures: # get every creature stored in the game
		creature = Globals.creatures.get(creature);
		create_creature_spawner(creature);
	
	for object in Globals.objects: # get every object stored in the game
		object = Globals.objects.get(object);
		create_object_spawner(object);

func _creature_created(key: String): ## add another creature to the add list when one is created
	var creature = Globals.creatures.get(key);
	create_creature_spawner(creature);
func _object_created(key: String): ## add another object to the add list when one is created
	var object = Globals.objects.get(key);
	create_object_spawner(object);


func create_creature_spawner(creature: FigureData): ## creates an object spawner given a FigureData
	print(creature);
	var new_creature_spawner = SPAWN_OBJECT_ON_BOARD.instantiate();
	new_creature_spawner.object_type = "creature";
	new_creature_spawner.object_data = creature;
	self.add_child(new_creature_spawner);
	object_spawners.append(new_creature_spawner);
	new_creature_spawner.show();
func create_object_spawner(object: ObjectData): ## creates an object spawner given an ObjectData
	print(object);
	var new_object_spawner = SPAWN_OBJECT_ON_BOARD.instantiate();
	new_object_spawner.object_type = "object";
	new_object_spawner.object_data = object;
	self.add_child(new_object_spawner);
	object_spawners.append(new_object_spawner);
	new_object_spawner.show();


func _on_line_edit_text_changed(new_text: String) -> void: ## A searchbar. show/hide object_spawners when the line_edit search field is edited 
	var index = 0; # index of the object loop
	for object_spawner in object_spawners:
		if(object_spawner != null): # first check if the object is not already freed
			if(new_text == ""): # when the text is empty, show all
				object_spawner.show();
			elif(object_spawner.object_data.name.to_lower().contains(new_text.to_lower())):
				object_spawner.show();
			else:
				object_spawner.hide();
			index += 1;
		else:
			object_spawners.remove_at(index);
