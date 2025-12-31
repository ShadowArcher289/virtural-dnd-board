extends Control

@onready var board_saver: Control = $BoardSaver
@onready var save_load_board: Button = $SaveLoadBoard

func _ready() -> void:
	save_load_board.focus_mode = Control.FOCUS_NONE;
	board_saver.hide();

func _on_save_load_board_pressed() -> void:
	if(board_saver.is_visible_in_tree()):
		board_saver.hide();
	else:
		board_saver.show();
