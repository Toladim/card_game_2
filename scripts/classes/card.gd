extends Control
class_name Card

@onready var texture_rect: TextureRect = $TextureRect
@onready var card_name: Label = $card_name

var card_data = CardData

func setup(data : CardData):
	card_data = data
	texture_rect.texture = data.texture
	card_name.text = data.card_name
