extends Node

signal creature_created(key: String); ## signal that a creature is created and the creature's name
signal map_uploaded(key: String); ## signal that a map is uploaded and the map's name
signal object_created(key: String); ## signal that an object is created and the object's name

signal creature_selected(creature: Dictionary); ## signal a creature has been selected from a user-click
signal area_of_effect_selected(area_of_effect: String); ## signal a AOE has been selected

signal mouse_collided(); ## signals that the mouse has clicked and collided with an object.

signal toggled_2d(toggled_on: bool); ## signals that 2d is toggled on or off

signal board_loaded(); ## signals that a board has been loaded

signal switch_map(map_key: String); ## signal to switch the map and the name of the map to switch to.
