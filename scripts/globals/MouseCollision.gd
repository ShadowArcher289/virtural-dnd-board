## Holds mouse's collision location, state, and the currently selected creature. 
## States: MEASURE, ATTACK_AREA, SELECT, INFO
extends Node

var mouse_raycast_data: Dictionary; ## the data for the mouse click from the raycast (position: Vector3, normal: Vector3, face_index, collider_id: Node3D, collider, shape, rid)
var mouse_selector_raycast_data: Dictionary ## the data for the mouse click only for bases.
var mouse_raycast_collider: Node3D; ## the object the mouse clicked



enum State {
	MEASURE,
	ATTACK_AREA,
	SELECT,
	INFO,
}

var current_selected_creature: Dictionary = { ## the creature currently selected by the player. Its info is displayed in the Info tab.
	#"name": "Thri-Kreen", 
	#"image": load("res://assets/creatures/thri-kreen.jpg"), 
	#"stats": "Stats",
	#"description": "Cool ant person"
}

func remove_selected_creature() -> void:
	current_selected_creature = {};

var current_mouse_state = State.SELECT; ## The current mouse's state

func currentState(state: String) -> bool: ## Return the current state: MEASURE, ATTACK_AREA, SELECT, INFO
	match state.to_lower():
		"measure":
			return current_mouse_state == State.MEASURE;
		"attack_area":
			return current_mouse_state == State.ATTACK_AREA;
		"select":
			return current_mouse_state == State.SELECT;
		"info":
			return current_mouse_state == State.INFO;
		_:
			print_debug("Invalid State: " + state);
			return false;
	
func switchState(state: String) -> void: ## Switch the mouse's state: MEASURE, ATTACK_AREA, SELECT, INFO
	match state.to_lower():
		"measure":
			current_mouse_state = State.MEASURE;
		"attack_area":
			current_mouse_state = State.ATTACK_AREA;
		"select":
			current_mouse_state = State.SELECT;
		"info":
			current_mouse_state = State.INFO;
		_:
			print_debug("Invalid State: " + state);
