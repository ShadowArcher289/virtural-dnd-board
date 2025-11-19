extends MarginContainer

@onready var creature_name_text: RichTextLabel = $VBoxContainer/CreatureNameText
@onready var creature_stats_text: RichTextLabel = $VBoxContainer/CreatureStatsText
@onready var creature_description_text: RichTextLabel = $VBoxContainer/CreatureDescriptionText

@export var creature_name: String; ## info on creature's name
@export var creature_stats: String; ## info on creature's stats
@export var creature_description: String; ## general creature description

func _ready() -> void:
	pass;
