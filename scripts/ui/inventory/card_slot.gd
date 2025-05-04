extends Control
class_name CardSlot

@export var card_scene: PackedScene
@onready var card_container: Control = $CardContainer
@onready var quantity: Label = %quantity

var card_instance : Node = null

func load_slot(card_data: CardData):
	clear()
	
	card_instance = card_scene.instantiate() as Control
	card_instance.set_scale(Vector2(0.8, 0.8))
	card_container.add_child(card_instance)
	card_instance.setup(card_data)
	quantity.text = "1"

func clear():
	if card_instance and is_instance_valid(card_instance):
		card_instance.queue_free()
		card_instance = null
		quantity.text = ""
