extends VBoxContainer

const SPAWN_OBJECT_ON_BOARD = preload("res://scenes/user_interface/spawn_object_on_board.tscn")

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
	new_object_spawner.object_image_path = creature.get("image_path");
	new_object_spawner.creature_stats = creature.get("name");
	self.add_child(new_object_spawner);
	new_object_spawner.show();
	
