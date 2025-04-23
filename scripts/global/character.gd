extends Node2D
class_name Character

@export var character_name: String = "Character"
var health: int = 0
var max_health: int = 0
var block: int = 0
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
