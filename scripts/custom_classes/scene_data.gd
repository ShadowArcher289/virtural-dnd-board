extends Resource
class_name SceneData

# from the board:
@export var board_items_array: Array[PackedScene];

# from Globals:
@export var toggle_2d = false; ## from Globals:
@export var creatures: Dictionary = {}; ## from Globals
@export var maps: Dictionary = {}; ## from Globals
@export var objects: Dictionary = {}; ## from Globals

# from UserResourceManager:
@export var figure_image: Dictionary = {}; ## from UserResourceManager
@export var map_image: Dictionary = {}; ## from UserResourceManager
@export var object_model: Dictionary = {}; ## from UserResourceManager
