extends Control

@onready var foldable_container: FoldableContainer = $FoldableContainer

@onready var counter_label: Label = $FoldableContainer/VBoxContainer/CounterLabel

@onready var increase: Button = $FoldableContainer/VBoxContainer/HBoxContainer/Increase
@onready var decrease: Button = $FoldableContainer/VBoxContainer/HBoxContainer/Decrease

@export var turn_count = 0;

func _ready() -> void:
	foldable_container.focus_mode = Control.FOCUS_NONE;
	
	increase.focus_mode = Control.FOCUS_NONE;
	decrease.focus_mode = Control.FOCUS_NONE;

func _on_decrease_pressed() -> void:
	turn_count -= 1;
	counter_label.text = str(turn_count);

func _on_increase_pressed() -> void:
	turn_count += 1;
	counter_label.text = str(turn_count);
