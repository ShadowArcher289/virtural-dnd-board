extends Control

@onready var ruler: Node3D = $Ruler

@onready var circle_area: Button = $MarginContainer/GridContainer/CircleArea
@onready var square_area: Button = $MarginContainer/GridContainer/SquareArea
@onready var cone_area: Button = $MarginContainer/GridContainer/ConeArea
@onready var rectangle_area: Button = $MarginContainer/GridContainer/RectangleArea


func _on_circle_area_pressed() -> void:
	ruler.switch_aoe_state("atk_aoe_circle");
	MouseCollision.switchState("attack_area");
	square_area.toggle_mode = false;
	cone_area.toggle_mode = false;
	rectangle_area.toggle_mode = false;
	SignalBus.area_of_effect_selected.emit("atk_aoe_circle");

func _on_square_area_pressed() -> void:
	ruler.switch_aoe_state("atk_aoe_square");
	MouseCollision.switchState("attack_area");
	circle_area.toggle_mode = false;
	cone_area.toggle_mode = false;
	rectangle_area.toggle_mode = false;
	SignalBus.area_of_effect_selected.emit("atk_aoe_square");

func _on_cone_area_pressed() -> void:
	ruler.switch_aoe_state("atk_aoe_cone");
	MouseCollision.switchState("attack_area");
	circle_area.toggle_mode = false;
	square_area.toggle_mode = false;
	rectangle_area.toggle_mode = false;
	SignalBus.area_of_effect_selected.emit("atk_aoe_cone");

func _on_rectangle_area_pressed() -> void:
	ruler.switch_aoe_state("atk_aoe_rectangle");
	MouseCollision.switchState("attack_area");
	circle_area.toggle_mode = false;
	cone_area.toggle_mode = false;
	square_area.toggle_mode = false;
	SignalBus.area_of_effect_selected.emit("atk_aoe_rectangle");
