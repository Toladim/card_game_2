extends Control
class_name CardInventoryUI

@export var card_slot_scene : PackedScene
@export var max_cards_per_page : int = 16
@export var columns : int = 4

@onready var grid : GridContainer = %CardGrid
@onready var prev_button: Button = %PrevButton
@onready var next_button: Button = %NextButton

var cards : Array[CardData] = []
var current_page : int = 0
var slot_pool : Array[CardSlot] = []

func _ready() -> void:
	grid.columns = columns
	_create_slot_pool()
	# --- TEST: pobierz karty z danych gracza ---
	if Engine.is_editor_hint(): return  # nie rób tego w edytorze
	var player_data = SaveManager.load_game()
	if player_data:
		for id in player_data.deck_ids:
			var card = DeckDatabase.get_card(id) as CardData
			if card:
				add_card(card)
	_update_page()

func _create_slot_pool():
	for i in range(max_cards_per_page):
		var slot = card_slot_scene.instantiate() as CardSlot
		slot.visible = false
		grid.add_child(slot)
		slot_pool.append(slot)

func _update_page():
	var start_index = current_page * max_cards_per_page
	var end_index = min(start_index + max_cards_per_page, cards.size())
	
	for i in range(max_cards_per_page):
		var slot = slot_pool[i]
		if i + start_index < end_index:
			var card = cards[i + start_index]
			slot.load_slot(card)
			print(card.card_name)
			slot.visible = true
		else:
			slot.clear()
			slot.visible = false
	
	_update_navigation()

func _update_navigation():
	var total_pages = ceil(float(cards.size())/ max_cards_per_page)
	prev_button.disabled = current_page <= 0
	next_button.disabled = current_page >= total_pages - 1
	#self.visible = not cards.is_empty()

func add_card(card: CardData) -> void:
	cards.append(card)
	_update_page()

func remove_card(card: CardData) -> void:
	if cards.has(card):
		cards.erase(card)
		if current_page > 0 and current_page * max_cards_per_page >= cards.size():
			current_page -= 1
		_update_page()

func _on_PrevButton_pressed():
	if current_page > 0:
		current_page -= 1
		_update_page()

func _on_NextButton_pressed():
	var total_pages = ceil(float(cards.size()) / max_cards_per_page)
	if current_page < total_pages - 1:
		current_page += 1
		_update_page()
