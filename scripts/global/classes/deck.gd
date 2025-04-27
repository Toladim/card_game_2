extends Node
class_name Deck

var cards : Array[CardData] = []

func draw_card() -> CardData:
	if cards.size() > 0:
		return cards.pop_front()
	return null
