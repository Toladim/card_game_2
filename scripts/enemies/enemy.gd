extends Character
class_name Enemy

@export var enemy_data: EnemyData

func _ready() -> void:
	super._ready()

	if not enemy_data:
		push_error("Brak przypisanego EnemyData!")
		return

	character_name = enemy_data.enemy_name
	health = enemy_data.max_health
	deck.cards = enemy_data.cards.duplicate(true)

	if has_node("Avatar"):
		$Avatar.texture = enemy_data.avatar
