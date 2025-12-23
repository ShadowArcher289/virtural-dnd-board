extends TextureButton

func _ready() -> void:
	self.focus_mode = Control.FOCUS_NONE;

func _on_toggled(toggled_on: bool) -> void:
	if(toggled_on):
		Globals.toggle_2d = true;
		SignalBus.toggled_2d.emit(true);
	else:
		Globals.toggle_2d = false;
		SignalBus.toggled_2d.emit(false);
