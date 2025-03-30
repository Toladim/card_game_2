extends Node
class_name Deck

@export var cards : Array[CardData] = []

func draw_cards() -> CardData:
	if cards.size() > 0:
		return cards.pop_front()
	return null
