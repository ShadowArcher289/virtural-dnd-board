## The data for a Figure object.
## Contains: name, image, stats, description, and status_rings
extends Resource
class_name FigureData

@export var name : String; ## the figure's name
@export var image := load("res://assets/creatures/thri-kreen.jpg"); ## the figure's image
@export var stats : Dictionary; ## the figure's stats
@export var description : String; ## the figure's description
@export var status_rings : Dictionary; ## colors that are true have their corresponding ring visible

func _init(f_name: String, f_image: Resource, f_stats: Dictionary={"ability_scores": [10, 10, 10, 10, 10, 10]}, f_description: String ="") -> void:
	self.name = f_name;
	self.image = f_image;
	self.stats = f_stats;
	self.description = f_description;
	self.status_rings = {"red": false, "orange": false, "yellow": false, "green": false, "blue": false, "purple": false, "pink": false, "white": false};

func _to_string() -> String:
	return "name: [" + name + "] image: [" + str(image) + "] stats: [" + str(stats) + "] description: [" + description + "]";
