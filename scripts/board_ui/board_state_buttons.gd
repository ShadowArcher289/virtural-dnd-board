extends HBoxContainer
@onready var current_state: Label = $CurrentState

func _ready() -> void:
	current_state.text = "Select";

func _on_attack_area_pressed() -> void:
	MouseCollision.switchState("attack_area");
	current_state.text = "Area";

func _on_measure_pressed() -> void:
	MouseCollision.switchState("measure");
	current_state.text = "Measure";

func _on_select_pressed() -> void:
	MouseCollision.switchState("select");
	current_state.text = "Select";

func _on_info_pressed() -> void:
	MouseCollision.switchState("info");
	current_state.text = "Info";
