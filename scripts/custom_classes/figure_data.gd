## The data for a Figure object.
## Contains: name, image, stats, description, and status_rings
extends Resource
class_name FigureData

@export var name : String; ## the figure's name
@export var image := load("res://assets/creatures/thri-kreen.jpg"); ## the figure's image
@export var stats : Dictionary; ## the figure's stats
@export var description : String; ## the figure's description
@export var status_rings : Dictionary; ## colors that are true have their corresponding ring visible

## Create a new FigureData, if f_copy_figure_data is not null, then instead make a deep copy using that data.
func _init(f_name: String="Figure", f_image: Resource=load("res://icon.svg"), f_stats: Dictionary={"ability_scores": [10, 10, 10, 10, 10, 10], "max_hp": 30}, f_description: String ="", copy: FigureData = null) -> void:
	if(copy != null): # make a deep copy
		self.name = copy.name;
		self.image = copy.image.duplicate_deep();
		self.stats = copy.stats.duplicate_deep();
		self.description = copy.description;
		self.status_rings = copy.status_rings.duplicate_deep();
	else:
		self.name = f_name;
		self.image = f_image;
		self.stats = f_stats;
		self.description = f_description;
		self.status_rings = {"red": false, "orange": false, "yellow": false, "green": false, "blue": false, "purple": false, "pink": false, "white": false};
	

func _to_string() -> String:
	return "name: [" + name + "] image: [" + str(image) + "] stats: [" + str(stats) + "] description: [" + description + "]";
