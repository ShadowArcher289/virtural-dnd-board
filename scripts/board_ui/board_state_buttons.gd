extends HBoxContainer

func _on_attack_area_pressed() -> void:
	MouseCollision.switchState("attack_area");

func _on_measure_pressed() -> void:
	MouseCollision.switchState("measure");

func _on_select_pressed() -> void:
	MouseCollision.switchState("select");

func _on_info_pressed() -> void:
	MouseCollision.switchState("info");
