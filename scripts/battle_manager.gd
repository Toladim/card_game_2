extends Node

@onready var player: CharacterBody2D = %Player
@onready var enemy: CharacterBody2D = %Enemy

var player_cards_on_board : Array[Card] = []
var enemy_cards_on_board : Array[Card] = []

func start_battle():
	for i in range(5):
		var player_card_data = player.deck.draw_card()
		var enemy_card_data = enemy.deck.draw_card()
