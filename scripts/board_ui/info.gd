extends MarginContainer

@onready var creature_name_text: RichTextLabel = $VBoxContainer/CreatureNameText
@onready var creature_description_text: RichTextLabel = $VBoxContainer/CreatureDescriptionText

# Labels for each of the creature's stats
@onready var str_data: Label = $VBoxContainer/StatsContainer/Str/StrData
@onready var dex_data: Label = $VBoxContainer/StatsContainer/Dex/DexData
@onready var con_data: Label = $VBoxContainer/StatsContainer/Con/ConData
@onready var int_data: Label = $VBoxContainer/StatsContainer/Int/IntData
@onready var wis_data: Label = $VBoxContainer/StatsContainer/Wis/WisData
@onready var cha_data: Label = $VBoxContainer/StatsContainer/Cha/ChaData

@export var creature_name: String; ## Info on creature's name.
@export var creature_stats: Dictionary; ## Info on creature's stats.
@export var creature_description: String; ## General creature description.

func _ready() -> void:
	SignalBus.creature_selected.connect(_creature_selected);

func _creature_selected(creature: Dictionary) -> void:
	var ability_scores: Array = creature.get("stats").get("ability_scores");
	creature_name_text.text = creature.get("name");
	str_data.text = str(ability_scores[0]);
	dex_data.text = str(ability_scores[1]);
	con_data.text = str(ability_scores[2]);
	int_data.text = str(ability_scores[3]);
	wis_data.text = str(ability_scores[4]);
	cha_data.text = str(ability_scores[5]);
	creature_description_text.text = creature.get("description");
