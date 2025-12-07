extends HBoxContainer
@onready var current_state: Label = $CurrentState

@onready var attack_area: Button = $AttackArea
@onready var measure: Button = $Measure
@onready var select: Button = $Select
@onready var info: Button = $Info


@onready var selection_arrow: Sprite2D = $SelectionArrow ## The arrow that will indicate which state button is currently active.

func _ready() -> void:
	current_state.text = "Select";
	selection_arrow.position = select.position + Vector2(50, -15);
	selection_arrow.hide();

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("to_board_state_attack_area")):
		_on_attack_area_pressed();
	elif(event.is_action_pressed("to_board_state_measure")):
		_on_measure_pressed();
	elif(event.is_action_pressed("to_board_state_select")):
		_on_select_pressed();
	elif(event.is_action_pressed("to_board_state_info")):
		_on_info_pressed();

func _on_attack_area_pressed() -> void:
	MouseCollision.switchState("attack_area");
	current_state.text = "Area";
	selection_arrow.position = attack_area.position + Vector2(50, -15);
	selection_arrow.show();

func _on_measure_pressed() -> void:
	MouseCollision.switchState("measure");
	current_state.text = "Measure";
	selection_arrow.position = measure.position + Vector2(50, -15);
	selection_arrow.show();

func _on_select_pressed() -> void:
	MouseCollision.switchState("select");
	current_state.text = "Select";
	selection_arrow.position = select.position + Vector2(50, -15);
	selection_arrow.show();

func _on_info_pressed() -> void:
	MouseCollision.switchState("info");
	current_state.text = "Info";
	selection_arrow.position = info.position + Vector2(50, -15);
	selection_arrow.show();
