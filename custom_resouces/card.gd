extends Resource
class_name Card

enum Type {ATTACK, SKILL, POWER}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}

@export_category("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target

func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY
