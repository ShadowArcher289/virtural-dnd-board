extends Node

var mouse_raycast_data: Dictionary; ## the data for the mouse click from the raycast (position: Vector3, normal: Vector3, face_index, collider_id: Node3D, collider, shape, rid)
var mouse_raycast_collider: Node3D; ## the object the mouse clicked

var creatures: Dictionary = { ## dictionary for all the creatures made in the game
	"thri_kreen": {
		"name": "Thri-Kreen", 
		"image": load("res://assets/creatures/thri-kreen.jpg"), 
		"stats": "Stats",
		"description": "Cool ant person"
	},
	"bard": {
		"name": "Bard", 
		"image": load("res://assets/creatures/bard.png"), 
		"stats": "Stats",
		"description": "A dragon's favorite"
	},
}
