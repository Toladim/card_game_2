extends Control
class_name CardSlot

@export var card_scene: PackedScene

@onready var card_slot: CardSlot = $"."
@onready var quantity: Label = %quantity

var card_instance : Node = null


#test

var card_dataa = CardData.new()

func _ready() -> void:
	load_slot(card_dataa)

func load_slot(card_data: CardData):
	clear()
	
	card_instance = card_scene.instantiate()
	card_slot.add_child(card_instance)
	card_instance.setup(card_data)
	quantity.text = "1"

func clear():
	if card_instance and is_instance_valid(card_instance):
		card_instance.queue_free()
		card_instance = null
		quantity.text = ""
