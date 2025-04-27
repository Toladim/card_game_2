extends Character
class_name Enemy

@export var enemy_data: EnemyData

func _ready() -> void:
	super._ready()

	if not enemy_data:
		push_error("Brak przypisanego EnemyData!")
		return

	character_name = enemy_data.char_name
	health = enemy_data.max_health
	deck = Deck.new()
	for id in enemy_data.deck_ids:
		var card = DeckDatabase.get_card(id)
		if card:
			deck.cards.append(card)

	if has_node("Avatar"):
		$Avatar.texture = enemy_data.avatar
