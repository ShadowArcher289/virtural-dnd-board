extends Node

signal creature_created(key: String); ## signal that a creature is created and the creature's name

signal creature_selected(creature: Dictionary); ## signal a creature has been selected from a user-click
