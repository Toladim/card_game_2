extends CharacterData
class_name PlayerData

@export var owned_cards : Dictionary = {}

func add_to_collection(card_id: String, amount: int = 1) -> void:
	if owned_cards.has(card_id):
		owned_cards[card_id] += amount
	else:
		owned_cards[card_id] = amount

func remove_from_collection(card_id: String, amount: int = 1) -> void:
	if not owned_cards.has(card_id):
		return
	owned_cards[card_id] = max(0, owned_cards[card_id] - amount)
	if owned_cards[card_id] == 0:
		owned_cards.erase(card_id)
	while deck_ids.count(card_id) > owned_cards.get(card_id, 0):
		deck_ids.erase(card_id)
		
func set_battle_deck(new_deck: Array[String]) -> void:
	deck_ids = new_deck.slice(0, min(new_deck.size(), 10))
