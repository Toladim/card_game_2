extends Node2D
class_name Character

@export var character_name: String = "Character"
var health: int = 0
var max_health: int = 0
var deck: Deck

func _ready() -> void:
	deck = Deck.new()

func take_damage(amount: int):
	health -= amount
	if health < 0:
		health = 0
