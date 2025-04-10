extends Node

@export var card_scene : PackedScene

@onready var enemy_card_container: HBoxContainer = $battle_ui/Control/MarginContainer/HBoxContainer/enemy_card_container
@onready var player_card_container: HBoxContainer = $battle_ui/Control2/MarginContainer2/HBoxContainer/player_card_container
@onready var player: CharacterBody2D = %Player
@onready var enemy: CharacterBody2D = %Enemy
@onready var enemy_name: Label = $battle_ui/Control/MarginContainer/HBoxContainer/HBoxContainer2/enemy_container/enemy_name
@onready var enemy_avatar: TextureRect = $battle_ui/Control/MarginContainer/HBoxContainer/Control/enemy_avatar
@onready var player_avatar: TextureRect = $battle_ui/Control2/MarginContainer2/HBoxContainer/Control/player_avatar

var current_enemy : EnemyData = preload("res://scenes/decks/test_enemy_data_01.tres")

func _ready():
	start_battle()
	
func start_battle():
	var player_deck = SaveManager.load_game()
	player.deck = Deck.new()
	for id in player_deck:
		var card_data = DeckDatabase.get_card(id)
		if card_data != null:
			player.deck.cards.append(card_data)
	
	var player_health 
	
	enemy.enemy_data = current_enemy
	enemy.deck = Deck.new()
	enemy.deck.cards = enemy.enemy_data.cards.duplicate(true)
	enemy_name.text = current_enemy.enemy_name
	enemy_avatar.texture = current_enemy.avatar
	enemy.health = current_enemy.max_health
	
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
