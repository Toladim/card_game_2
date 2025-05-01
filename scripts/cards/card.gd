extends Control
class_name Card

@onready var texture_rect: TextureRect = $TextureRect
@onready var card_name: Label = $card_name

var card_data : CardData
var is_ready: bool = false

func _ready() -> void:
	is_ready = true
	if card_data:
		apply_data()

func setup(data: CardData):
	card_data = data

func apply_data():
	if texture_rect:
		texture_rect.texture = card_data.texture
	if card_name:
		card_name.text = card_data.card_name
