extends CardEffect
class_name HealEffect

@export var amount : int = 0

func apply(user: Character, target: Character):
	print(user.character_name, " leczy się o ", amount)
	user.heal(amount)
