extends Node

var toggle_2d = false; ## if true: go to 2D, if false; go to 3D

var creatures: Dictionary = { ## dictionary for all the creatures made in the game
	"thri-kreen": FigureData.new("Thri-Kreen", load("res://assets/creatures/thri-kreen.jpg"), {"ability_scores": [12, 13, 4, 5, 12, 53]}, "Cool ant person"),
	#"thri_kreen": {
		#"name": "Thri-Kreen", 
		#"image": load("res://assets/creatures/thri-kreen.jpg"), 
		#"stats": {"ability_scores": [12, 13, 4, 5, 12, 53]},
		#"description": "Cool ant person"
	#},
	"bard": FigureData.new("Bard", load("res://assets/creatures/bard.png"), {"ability_scores": [12, 13, 4, 5, 12, 53]}, "A dragon's favorite")
	#"bard": {
		#"name": "Bard", 
		#"image": load("res://assets/creatures/bard.png"), 
		#"stats": {"ability_scores": [12, 13, 4, 5, 12, 53]},
		#"description": "A dragon's favorite"
	#},
}

var maps: Dictionary = { ## dictionary for all the maps in the game
	"forest": {
		"name": "Forest",
		"image": load("res://assets/board_maps/ForestEncampment_digital_day_grid.jpg")
	}
}

var objects: Dictionary = { ## dictionary for all the maps in the game
	"wooden_chest": ObjectData.new("Wooden Chest", null, null, load("res://assets/3d_models/default_models/wooden_chest.glb"), false),
}
