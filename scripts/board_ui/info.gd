extends MarginContainer

@onready var creature_name_text: RichTextLabel = $VBoxContainer/CreatureNameText
@onready var creature_stats_text: RichTextLabel = $VBoxContainer/CreatureStatsText
@onready var creature_description_text: RichTextLabel = $VBoxContainer/CreatureDescriptionText

@export var creature_name: String; ## Info on creature's name.
@export var creature_stats: String; ## Info on creature's stats.
@export var creature_description: String; ## General creature description.

func _ready() -> void:
	SignalBus.creature_selected.connect(_creature_selected);

func _creature_selected(creature: Dictionary) -> void:
	print_debug("Creature_Selected")
	creature_name_text.text = creature.get("name");
	creature_stats_text.text = creature.get("stats");
	creature_description_text.text = creature.get("description");
