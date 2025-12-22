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

# Checkboxes to toggle the rings
@onready var red_ring_toggle: CheckBox = $VBoxContainer/CreatureConditionRings/VBoxContainer/RedRingToggle
@onready var orange_ring_toggle: CheckBox = $VBoxContainer/CreatureConditionRings/VBoxContainer/OrangeRingToggle
@onready var yellow_ring_toggle: CheckBox = $VBoxContainer/CreatureConditionRings/VBoxContainer/YellowRingToggle
@onready var green_ring_toggle: CheckBox = $VBoxContainer/CreatureConditionRings/VBoxContainer/GreenRingToggle
@onready var blue_ring_toggle: CheckBox = $VBoxContainer/CreatureConditionRings/VBoxContainer/BlueRingToggle
@onready var purple_ring_toggle: CheckBox = $VBoxContainer/CreatureConditionRings/VBoxContainer/PurpleRingToggle
@onready var pink_ring_toggle: CheckBox = $VBoxContainer/CreatureConditionRings/VBoxContainer/PinkRingToggle
@onready var white_ring_toggle: CheckBox = $VBoxContainer/CreatureConditionRings/VBoxContainer/WhiteRingToggle

@export var creature_data: FigureData;
@export var creature_object: Node; ## the object of the creature, primarily used to modify its values

func _ready() -> void:
	SignalBus.creature_selected.connect(_creature_selected);

func _process(_delta: float) -> void:
	if(creature_object != null):
		toggle_ring(red_ring_toggle, "red");
		toggle_ring(orange_ring_toggle, "orange");
		toggle_ring(yellow_ring_toggle, "yellow");
		toggle_ring(green_ring_toggle, "green");
		toggle_ring(blue_ring_toggle, "blue");
		toggle_ring(purple_ring_toggle, "purple");
		toggle_ring(pink_ring_toggle, "pink");
		toggle_ring(white_ring_toggle, "white");

func _creature_selected(creature: Dictionary) -> void: ## triggered when the Signal SignalBus.creature_selected is emitted.
	var ability_scores: Array = creature.get("data").stats.get("ability_scores");
	set_rings(creature.get("data").get("status_rings"));
	creature_object = creature.get("object");
	creature_name_text.text = creature.get("data").name;
	str_data.text = str(ability_scores[0]);
	dex_data.text = str(ability_scores[1]);
	con_data.text = str(ability_scores[2]);
	int_data.text = str(ability_scores[3]);
	wis_data.text = str(ability_scores[4]);
	cha_data.text = str(ability_scores[5]);
	creature_description_text.text = creature.get("data").description;


func toggle_ring(ring: CheckBox, color: String): ## helper function: toggle status_rings based on uf the respective checkbox is pressed on or off
	if(ring.button_pressed):
		creature_object.object_data.status_rings.set(color, true);
	else:
		creature_object.object_data.status_rings.set(color, false);

func set_rings(rings: Dictionary): ## update the checkboxes so that only the ones with the currently visible colors are checked
	if(rings.get("red") == true):
		red_ring_toggle.button_pressed = true;
	else:
		red_ring_toggle.button_pressed = false;
	if(rings.get("orange") == true):
		orange_ring_toggle.button_pressed = true;
	else:
		orange_ring_toggle.button_pressed = false;
	if(rings.get("yellow") == true):
		yellow_ring_toggle.button_pressed = true;
	else:
		yellow_ring_toggle.button_pressed = false;
	if(rings.get("green") == true):
		green_ring_toggle.button_pressed = true;
	else:
		green_ring_toggle.button_pressed = false;
	if(rings.get("blue") == true):
		blue_ring_toggle.button_pressed = true;
	else:
		blue_ring_toggle.button_pressed = false;
	if(rings.get("purple") == true):
		purple_ring_toggle.button_pressed = true;
	else:
		purple_ring_toggle.button_pressed = false;
	if(rings.get("pink") == true):
		pink_ring_toggle.button_pressed = true;
	else:
		pink_ring_toggle.button_pressed = false;
	if(rings.get("white") == true):
		white_ring_toggle.button_pressed = true;
	else:
		white_ring_toggle.button_pressed = false;
	

		
