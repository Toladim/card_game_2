extends Node2D
class_name Character

signal health_changed(new_hp)
signal block_changed(new_block)
signal name_changed(new_name)


@export var character_name: String = "Character" :
	set(value):
		character_name = value
		emit_signal("name_changed", value)

@export var max_health: int = 30

var health: int = 30 :
	set(value):
		health = clamp(value, 0, max_health)
		emit_signal("health_changed", value)
		
@export var block: int = 0 :
	set(value):
		block = max(value, 0)
		emit_signal("block_changed", value)

var deck: Deck

func _ready() -> void:
	deck = Deck.new()

func take_damage(amount: int):
	var final_damage = max(amount - block, 0)
	block = max(block - block, 0)
	health -= final_damage
	if health < 0:
		health = 0
		print(character_name, " otrzymał ", final_damage, " obrażeń (pozostałe HP: ", health, ")")

func add_block(amount: int):
	block += amount
	print(character_name, " zyskał ", amount, " bloków.")
