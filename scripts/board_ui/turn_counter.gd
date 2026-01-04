extends Control

@onready var foldable_container: FoldableContainer = $FoldableContainer
@onready var turn_count_info: TextEdit = $FoldableContainer/HBoxContainer/TurnCountInfo

@onready var counter_label: Label = $FoldableContainer/HBoxContainer/VBoxContainer/CounterLabel

@onready var decrease: Button = $FoldableContainer/HBoxContainer/VBoxContainer/HBoxContainer/Decrease
@onready var increase: Button = $FoldableContainer/HBoxContainer/VBoxContainer/HBoxContainer/Increase



func _ready() -> void:
	SignalBus.board_loaded.connect(_board_loaded);
	foldable_container.focus_mode = Control.FOCUS_NONE;
	
	increase.focus_mode = Control.FOCUS_NONE;
	decrease.focus_mode = Control.FOCUS_NONE;

func _board_loaded() -> void:
	counter_label.text = str(Globals.turn_count);
	turn_count_info.text = Globals.count_info;

func _on_decrease_pressed() -> void:
	Globals.turn_count -= 1;
	counter_label.text = str(Globals.turn_count);

func _on_increase_pressed() -> void:
	Globals.turn_count += 1;
	counter_label.text = str(Globals.turn_count);


func _on_turn_count_info_text_changed() -> void:
	Globals.count_info = turn_count_info.text;
