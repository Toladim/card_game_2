extends CardEffect
class_name DamageEffect

@export var amount : int = 0

func apply(user: Character, target: Character):
	print(user.character_name, " zadaje ", amount, " obrażeń ", target.character_name)
	target.take_damage(amount)
