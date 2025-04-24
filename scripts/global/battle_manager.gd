extends Node

@export var card_scene : PackedScene
@onready var enemy: Character = %Enemy
@onready var enemy_avatar: TextureRect = $battle_ui/Control/MarginContainer/HBoxContainer/Control/enemy_avatar
@onready var enemy_card_container: HBoxContainer = $battle_ui/Control/MarginContainer/HBoxContainer/enemy_card_container
@onready var enemy_name: Label = $battle_ui/Control/MarginContainer/HBoxContainer/HBoxContainer2/enemy_container/enemy_name
@onready var player: Character = %Player
@onready var player_avatar: TextureRect = $battle_ui/Control2/MarginContainer2/HBoxContainer/Control/player_avatar
@onready var player_card_container: HBoxContainer = $battle_ui/Control2/MarginContainer2/HBoxContainer/player_card_container
@onready var player_name: Label = $battle_ui/Control2/MarginContainer2/HBoxContainer/HBoxContainer2/player_container/player_name


var current_enemy : EnemyData = preload("res://scenes/decks/test_enemy_data_01.tres")

var battle_in_progress : bool = false

func _ready():
	start_battle()
	
func start_battle():
	var data = GameSession.player_data
	if not data:
		push_error("brak danych gracza")
		return
	
	player.deck = Deck.new()
	for id in data.deck_ids:
		var card = DeckDatabase.get_card(id)
		if card:
			player.deck.cards.append(card)
	
	player.health = data.current_health
	
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
	
	battle_in_progress = true
	start_turn()
	
func start_turn():
	if not battle_in_progress:
		return
	await get_tree().create_timer(1.0).timeout # krótka przerwa między turami
	
	var p_card = player.deck.draw_card()
	var e_card = enemy.deck.draw_card()
	print(player.deck.cards)
	print("turn started")
	if p_card:
		apply_card_effect(p_card, player, enemy)
		print("hello from p_card")
	if e_card:
		apply_card_effect(e_card, enemy, player)
		print("hello from e_card")
	
	
	
func apply_card_effect(card: CardData, user: Character, target: Character):
	match card.type:
		CardData.Type.ATTACK:
			print(user.character_name, " atakuje za ", card.attack)
			target.take_damage(card.attack)
		CardData.Type.SKILL:
			print(user.character_name, "uzywa skill'a")
			
func end_turn(result_text: String):
	battle_in_progress = false
	print(result_text)
