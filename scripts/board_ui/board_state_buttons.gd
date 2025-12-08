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
	selection_arrow.show();

func _process(_delta: float) -> void:
	adjust_selection_arrow_position("");

func adjust_selection_arrow_position(state: String) -> void: ## adjust the position of the selection arrow to a specified button, or by default search automatically.
	var arrow_position: Vector2 = Vector2(50, -15);
	match state.to_lower():
		"measure":
			selection_arrow.position = measure.position + arrow_position;
		"attack_area":
			selection_arrow.position = attack_area.position + arrow_position;
		"select":
			selection_arrow.position = select.position + arrow_position;
		"info":
			selection_arrow.position = info.position + arrow_position;
		_: # do automatic search if no state is given
			if(MouseCollision.currentState("measure")):
				selection_arrow.position = measure.position + arrow_position;
			elif(MouseCollision.currentState("attack_area")):
				selection_arrow.position = attack_area.position + arrow_position;
			elif(MouseCollision.currentState("select")):
				selection_arrow.position = select.position + arrow_position;
			elif(MouseCollision.currentState("info")):
				selection_arrow.position = info.position + arrow_position;

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
	adjust_selection_arrow_position("attack_area");
	selection_arrow.show();

func _on_measure_pressed() -> void:
	MouseCollision.switchState("measure");
	current_state.text = "Measure";
	adjust_selection_arrow_position("measure");
	selection_arrow.show();

func _on_select_pressed() -> void:
	MouseCollision.switchState("select");
	current_state.text = "Select";
	adjust_selection_arrow_position("select");
	selection_arrow.show();

func _on_info_pressed() -> void:
	MouseCollision.switchState("info");
	current_state.text = "Info";
	adjust_selection_arrow_position("info");
	selection_arrow.show();
