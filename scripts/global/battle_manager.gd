extends Node

@export var card_scene : PackedScene

@onready var enemy_card_container: HBoxContainer = $battle_ui/Control/MarginContainer/HBoxContainer/enemy_card_container
@onready var player_card_container: HBoxContainer = $battle_ui/Control2/MarginContainer2/HBoxContainer/player_card_container
@onready var player: CharacterBody2D = %Player
@onready var enemy: CharacterBody2D = %Enemy

var player_cards_on_board : Array[Card] = []
var enemy_cards_on_board : Array[Card] = []

func _ready():
	start_battle()

func start_battle():
	var player_deck = SaveManager.load_deck()
	player.deck = Deck.new()
	for id in player_deck:
		var card_data = DeckDatabase.get_card(id)
		if card_data != null:
			player.deck.cards.append(card_data)
			
	enemy.deck = Deck.new()
	enemy.deck.cards = enemy.enemy_data.cards.duplicate(true)
	
	for e in enemy.deck.cards:
		print(e.card_name)
	# Stwórz 5 pierwszych kart na ekranie
	for i in range(5):
		var p_card_data = player.deck.draw_card()
		var e_card_data = enemy.deck.draw_card()
		if p_card_data:
			var card = card_scene.instantiate()
			card.setup(p_card_data)
			player_card_container.add_child(card)
		if e_card_data:
			var card = card_scene.instantiate()
			card.setup(e_card_data)
			enemy_card_container.add_child(card)
