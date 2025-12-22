extends Node

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

var maps: Dictionary = {
	"forest": {
		"name": "Forest",
		"image": load("res://assets/board_maps/ForestEncampment_digital_day_grid.jpg")
	}
}
