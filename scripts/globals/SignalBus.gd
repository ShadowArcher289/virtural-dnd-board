extends Node

signal creature_created(key: String); ## signal that a creature is created and the creature's name
signal map_uploaded(key: String); ## signal that a map is uploaded and the map's name

signal creature_selected(creature: Dictionary); ## signal a creature has been selected from a user-click
signal area_of_effect_selected(area_of_effect: String); ## signal a AOE has been selected

signal mouse_collided(); ## signals that the mouse has clicked and collided with an object.
