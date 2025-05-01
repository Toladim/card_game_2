extends CardEffect
class_name DamageEffect

@export var min_amount : int = 0
@export var max_amount : int = 0
func apply(user: Character, target: Character):
	var value =  randi_range(min_amount, max_amount)
	print(user.character_name, " zadaje ", value, " obrażeń ", target.character_name)
	target.take_damage(value)
