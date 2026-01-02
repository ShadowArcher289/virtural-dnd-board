extends Control

@onready var object_name_text: RichTextLabel = $VBoxContainer/ObjectNameText

# Labels for each of the creature's stats
@onready var stats_container: HBoxContainer = $VBoxContainer/StatsContainer
@onready var str_data: Label = $VBoxContainer/StatsContainer/Str/StrData
@onready var dex_data: Label = $VBoxContainer/StatsContainer/Dex/DexData
@onready var con_data: Label = $VBoxContainer/StatsContainer/Con/ConData
@onready var int_data: Label = $VBoxContainer/StatsContainer/Int/IntData
@onready var wis_data: Label = $VBoxContainer/StatsContainer/Wis/WisData
@onready var cha_data: Label = $VBoxContainer/StatsContainer/Cha/ChaData

# Edits for each model's position
@onready var model_position_container: HBoxContainer = $VBoxContainer/ModelPositionContainer
@onready var model_x: SpinBox = $VBoxContainer/ModelPositionContainer/ModelX
@onready var model_y: SpinBox = $VBoxContainer/ModelPositionContainer/ModelY
@onready var model_z: SpinBox = $VBoxContainer/ModelPositionContainer/ModelZ

# Edits for each model's scale
@onready var model_scale_container: HBoxContainer = $VBoxContainer/ModelScaleContainer
@onready var model_scale: SpinBox = $VBoxContainer/ModelScaleContainer/ModelScale

# Edits for each object's base's scale
@onready var base_scale_container: HBoxContainer = $VBoxContainer/BaseScaleContainer
@onready var base_scale_x: SpinBox = $VBoxContainer/BaseScaleContainer/BaseScaleX
@onready var base_scale_y: SpinBox = $VBoxContainer/BaseScaleContainer/BaseScaleY
@onready var base_scale_z: SpinBox = $VBoxContainer/BaseScaleContainer/BaseScaleZ

@onready var rotation_label: Label = $VBoxContainer/RotationLabel
@onready var rotation_slider: HSlider = $VBoxContainer/RotationSlider

@onready var toggle_base_visibility: CheckButton = $VBoxContainer/ToggleBaseVisibility

@onready var delete_button: Button = $VBoxContainer/DeleteButton

# variables to edit:
# Base scale

@export var object_data: Resource;
@export var object_node: Node; ## the object of the creature, primarily used to modify its values

var object_base: Node; ## the object's base.
var object_node_model; ## the root node that contains all the 3D model data for the object

func _ready() -> void:
	SignalBus.creature_selected.connect(_creature_selected);
	model_x.focus_mode = Control.FOCUS_NONE;
	model_y.focus_mode = Control.FOCUS_NONE;
	model_z.focus_mode = Control.FOCUS_NONE;
	
	base_scale_x.focus_mode = Control.FOCUS_NONE;
	base_scale_y.focus_mode = Control.FOCUS_NONE;
	base_scale_z.focus_mode = Control.FOCUS_NONE;
	
	toggle_base_visibility.focus_mode = Control.FOCUS_NONE;
	
	delete_button.focus_mode = Control.FOCUS_NONE;


func _creature_selected(object: Dictionary) -> void: ## triggered when the Signal SignalBus.creature_selected is emitted.
	object_data = object.get("data");
	object_node = object.get("object");
	
	match object.get("type"):
		"creature":
			var ability_scores: Array = object_data.stats.get("ability_scores");
			object_base = object_node.get_child(0);
			
			model_position_container.hide();
			base_scale_container.hide();
			stats_container.hide();
			
			object_name_text.text = object.get("data").name;

			str_data.text = str(ability_scores[0]);
			dex_data.text = str(ability_scores[1]);
			con_data.text = str(ability_scores[2]);
			int_data.text = str(ability_scores[3]);
			wis_data.text = str(ability_scores[4]);
			cha_data.text = str(ability_scores[5]);
		"object":
			object_node_model = object_node.get_child(-1); # sets the last node in the object to be the object_node_model
			object_base = object_node.get_child(0);
			
			model_position_container.show();
			base_scale_container.show();
			stats_container.hide();

			object_name_text.text = object.get("data").name;
			
			model_x.value = object_node_model.global_position.x;
			model_y.value = object_node_model.global_position.y;
			model_z.value = object_node_model.global_position.z;
			
			model_scale.value = object_node_model.scale.x;
			
			base_scale_x.value = object_base.scale.x;
			base_scale_y.value = object_base.scale.y;
			base_scale_z.value = object_base.scale.z;
		_:
			print_debug("Error: Invalid object_data.type");
		
		
	# ||| set input values to the objects current values |||
	rotation_slider.value = object_node.rotation_degrees.y;
	rotation_label.text = "Rotation Degrees (" + str(int(object_node.rotation_degrees.y)) + "\u00B0)";
	
	if((object_base != null) && object_base.is_visible_in_tree()): # check if base is already hidden or not
		toggle_base_visibility.button_pressed = true;
	else:
		toggle_base_visibility.button_pressed = false;


func _on_rotation_slider_value_changed(value: float) -> void:
	rotation_label.text = "Rotation Degrees (" + str(int(value)) + "\u00B0)";
	
	if(object_node != null):
		object_node.rotation_degrees.y = value;
	

func _on_toggle_base_visibility_toggled(toggled_on: bool) -> void:
	if(object_base != null):
		if(!toggled_on):
			object_base.hide(); # hide the base;
		else:
			object_base.show(); # show the base;

func _on_delete_button_pressed() -> void:
	object_node.queue_free();

# model position values
func _on_model_x_value_changed(value: float) -> void:
	if(object_node_model != null):
		object_node_model.global_position.x = value;
		object_node.model_modified_position.x = object_node_model.position.x;
		
func _on_model_y_value_changed(value: float) -> void:
	if(object_node_model != null):
		object_node_model.global_position.y = value;
		object_node.model_modified_position.y = object_node_model.position.y;

func _on_model_z_value_changed(value: float) -> void:
	if(object_node_model != null):
		object_node_model.global_position.z = value;
		object_node.model_modified_position.z = object_node_model.position.z;

# model scale values
func _on_model_scale_value_changed(value: float) -> void:
	if(object_node_model != null):
		object_node_model.scale = Vector3(value, value, value);
		object_node.model_modified_scale = Vector3(value, value, value);

# base scale values
func _on_base_scale_x_value_changed(value: float) -> void:
	if(object_base != null):
		object_base.scale.x = value;

func _on_base_scale_y_value_changed(value: float) -> void:
	if(object_base != null):
		object_base.scale.y = value;

func _on_base_scale_z_value_changed(value: float) -> void:
	if(object_base != null):
		object_base.scale.z = value;
