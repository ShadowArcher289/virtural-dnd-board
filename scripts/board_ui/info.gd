extends MarginContainer

@onready var object_name_text: RichTextLabel = $VBoxContainer/ObjectNameText
@onready var object_description_text: RichTextLabel = $VBoxContainer/ObjectDescriptionText

@onready var rotation_label: Label = $VBoxContainer/RotationLabel
@onready var rotation_slider: HSlider = $VBoxContainer/RotationSlider

# Labels for each of the creature's stats
@onready var stats_container: HBoxContainer = $VBoxContainer/StatsContainer
@onready var str_data: Label = $VBoxContainer/StatsContainer/Str/StrData
@onready var dex_data: Label = $VBoxContainer/StatsContainer/Dex/DexData
@onready var con_data: Label = $VBoxContainer/StatsContainer/Con/ConData
@onready var int_data: Label = $VBoxContainer/StatsContainer/Int/IntData
@onready var wis_data: Label = $VBoxContainer/StatsContainer/Wis/WisData
@onready var cha_data: Label = $VBoxContainer/StatsContainer/Cha/ChaData

# Checkboxes to toggle the rings
@onready var creature_condition_rings: FoldableContainer = $VBoxContainer/CreatureConditionRings
@onready var red_ring_toggle: CheckBox = $VBoxContainer/CreatureConditionRings/VBoxContainer/RedRingToggle
@onready var orange_ring_toggle: CheckBox = $VBoxContainer/CreatureConditionRings/VBoxContainer/OrangeRingToggle
@onready var yellow_ring_toggle: CheckBox = $VBoxContainer/CreatureConditionRings/VBoxContainer/YellowRingToggle
@onready var green_ring_toggle: CheckBox = $VBoxContainer/CreatureConditionRings/VBoxContainer/GreenRingToggle
@onready var blue_ring_toggle: CheckBox = $VBoxContainer/CreatureConditionRings/VBoxContainer/BlueRingToggle
@onready var purple_ring_toggle: CheckBox = $VBoxContainer/CreatureConditionRings/VBoxContainer/PurpleRingToggle
@onready var pink_ring_toggle: CheckBox = $VBoxContainer/CreatureConditionRings/VBoxContainer/PinkRingToggle
@onready var white_ring_toggle: CheckBox = $VBoxContainer/CreatureConditionRings/VBoxContainer/WhiteRingToggle

@export var object_data: Resource;
@export var object_node: Node; ## the object of the creature, primarily used to modify its values

func _ready() -> void:
	SignalBus.creature_selected.connect(_creature_selected);

func _process(_delta: float) -> void:
	if(object_node != null && (object_data is FigureData)):
		toggle_ring(red_ring_toggle, "red");
		toggle_ring(orange_ring_toggle, "orange");
		toggle_ring(yellow_ring_toggle, "yellow");
		toggle_ring(green_ring_toggle, "green");
		toggle_ring(blue_ring_toggle, "blue");
		toggle_ring(purple_ring_toggle, "purple");
		toggle_ring(pink_ring_toggle, "pink");
		toggle_ring(white_ring_toggle, "white");

func _creature_selected(object: Dictionary) -> void: ## triggered when the Signal SignalBus.creature_selected is emitted.
	object_data = object.get("data");
	object_node = object.get("object");
	
	rotation_slider.value = object_node.rotation_degrees.y;
	rotation_label.text = "Rotation Degrees (" + str(int(object_node.rotation_degrees.y)) + "\u00B0)";
	
	match object.get("type"):
		"creature":
			var ability_scores: Array = object_data.stats.get("ability_scores");
			set_rings(object_data.get("status_rings"));
			object_name_text.text = object.get("data").name;
			stats_container.show();
			str_data.text = str(ability_scores[0]);
			dex_data.text = str(ability_scores[1]);
			con_data.text = str(ability_scores[2]);
			int_data.text = str(ability_scores[3]);
			wis_data.text = str(ability_scores[4]);
			cha_data.text = str(ability_scores[5]);
			object_description_text.text = object.get("data").description;
			creature_condition_rings.show();
		"object":
			object_name_text.text = object.get("data").name;
			stats_container.hide();
			object_description_text.text = object.get("data").description;
			creature_condition_rings.hide();
		_:
			print_debug("Error: Invalid object_data.type");


func toggle_ring(ring: CheckBox, color: String): ## helper function: toggle status_rings based on uf the respective checkbox is pressed on or off
	if(ring.button_pressed):
		object_node.object_data.status_rings.set(color, true);
	else:
		object_node.object_data.status_rings.set(color, false);

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


func _on_rotation_slider_value_changed(value: float) -> void: # updates the rotation_label to the rotation slider's value
	rotation_label.text = "Rotation Degrees (" + str(int(value)) + "\u00B0)";
	if(object_node != null):
		object_node.rotation_degrees.y = value;
	
