extends Control

@onready var dice_sprite: AnimatedSprite2D = $DiceSprite
@onready var dice_value_text: RichTextLabel = $DiceValueText

const ROLL_AMOUNT = 5 ## Roll the dice this amount.

var randomizer = RandomNumberGenerator.new();
var dice_value = 10; ## The value of the dice.

func _on_button_pressed() -> void:
	roll_dice();

func roll_dice() -> void: ## Roll the dice.
	for i in range(ROLL_AMOUNT):
		dice_value = randomizer.randi_range(1, 20); # set the value
		dice_value_text.text = str(dice_value);
		await get_tree().create_timer(0.05).timeout;
