extends FoldableContainer

@onready var tab_container: TabContainer = $TabContainer

func _ready() -> void:
	SignalBus.creature_selected.connect(_creature_selected);

func _creature_selected(_creature: Dictionary) -> void: ## Switch tab to the info tab when a creature is selected
	print_debug("SELECTED")
	self.show();
	self.folded = false;
	tab_container.current_tab = 2;
