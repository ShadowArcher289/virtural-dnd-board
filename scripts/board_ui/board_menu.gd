extends FoldableContainer

@onready var tab_container: TabContainer = $VBoxContainer/TabContainer

func _ready() -> void:
	SignalBus.creature_selected.connect(_creature_selected);
	tab_container.current_tab = 0; # start the current tab at 0 to keep consistency even if editor is not setup right.
	
	tab_container.focus_mode = Control.FOCUS_NONE;

func _creature_selected(_creature: Dictionary) -> void: ## Switch tab to the info tab when a creature is selected
	if (MouseCollision.currentState("info")):
		self.show();
		self.folded = false;
		tab_container.current_tab = 2;
