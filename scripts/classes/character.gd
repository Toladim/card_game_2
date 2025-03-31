extends Node2D
class_name Character

@export var character_name : String = "Character"
@export var health : int = 0
@export var deck : Deck


func take_damage(amount: int):
	health -= amount
	if health < 0:
		health = 0
