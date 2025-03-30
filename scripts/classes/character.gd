extends Node
class_name Character

@export var name : String = ""
@export var health : int = 0
@export var deck : Deck

func take_damage(amount: int):
	health -= amount
	if health < 0:
		health = 0
