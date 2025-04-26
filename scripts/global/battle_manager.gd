extends Node

@export var card_scene : PackedScene
@onready var enemy: Character = %Enemy
@onready var enemy_avatar: TextureRect = $battle_ui/Control/MarginContainer/HBoxContainer/Control/enemy_avatar
@onready var enemy_card_container: HBoxContainer = $battle_ui/Control/MarginContainer/HBoxContainer/enemy_card_container
@onready var enemy_card_pile: Control = $battle_ui/Control/MarginContainer/HBoxContainer/enemy_card_pile
@onready var enemy_hp: ProgressBar = $battle_ui/Control/MarginContainer/HBoxContainer/HBoxContainer2/enemy_container/enemy_hp
@onready var enemy_mana: ProgressBar = $battle_ui/Control/MarginContainer/HBoxContainer/HBoxContainer2/enemy_container/enemy_mana
@onready var enemy_name: Label = $battle_ui/Control/MarginContainer/HBoxContainer/HBoxContainer2/enemy_container/enemy_name
@onready var player: Character = %Player
@onready var player_avatar: TextureRect = $battle_ui/Control2/MarginContainer2/HBoxContainer/Control/player_avatar
@onready var player_card_container: HBoxContainer = $battle_ui/Control2/MarginContainer2/HBoxContainer/player_card_container
@onready var player_card_pile: Control = $battle_ui/Control2/MarginContainer2/HBoxContainer/player_card_pile
@onready var player_hp: ProgressBar = $battle_ui/Control2/MarginContainer2/HBoxContainer/HBoxContainer2/player_container/player_hp
@onready var player_mana: ProgressBar = $battle_ui/Control2/MarginContainer2/HBoxContainer/HBoxContainer2/player_container/player_mana
@onready var player_name: Label = $battle_ui/Control2/MarginContainer2/HBoxContainer/HBoxContainer2/player_container/player_name

var current_enemy : EnemyData = preload("res://scenes/decks/test_enemy_data_01.tres")

var battle_in_progress : bool = false

func _ready():
	connect_character_ui(player, player_hp)
	connect_character_ui(enemy, enemy_hp)
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

	enemy.enemy_data = current_enemy
	enemy.deck = Deck.new()
	enemy.deck.cards = enemy.enemy_data.cards.duplicate(true)
	enemy.health = current_enemy.max_health
	enemy_avatar.texture = current_enemy.avatar
	enemy_hp.value = current_enemy.health
	enemy_hp.max_value = current_enemy.max_health
	enemy_name.text = current_enemy.enemy_name
	player.health = data.current_health
	player.max_health = data.max_health
	player_hp.max_value = player.max_health
	player_name.text = player.character_name
	
	if player.deck.cards.size() < 5:
		player_card_pile.find_child("TextureRect").hide()
		
	
	for i in range(min(5, player.deck.cards.size())):
		var p_card_data = player.deck.cards[i]
		var card = card_scene.instantiate()
		card.setup(p_card_data)
		player_card_container.add_child(card)
	
	for i in range(min(5, enemy.deck.cards.size())):
		var e_card_data = enemy.deck.cards[i]
		var card = card_scene.instantiate()
		card.setup(e_card_data)
		enemy_card_container.add_child(card)
	
	battle_in_progress = true
	start_turn(player, enemy) #mozna dodac pozniej randomizacje

func start_turn(user: Character, target: Character):
	if not battle_in_progress:
		return

	await get_tree().create_timer(2.0).timeout
	var card = user.deck.draw_card()
	if card:
		apply_card_effect(card, user, target)
	if target.health <=0 or target.deck.cards.size() <= 0:
		end_battle(str(user.character_name) +" wygrywa")
	elif user.health <=0 or user.deck.cards.size() <= 0:
		end_battle(str(target.character_name) +" wygrywa")
	else:
		start_turn(target, user)

func apply_card_effect(card: CardData, user: Character, target: Character):
	match card.type:
		CardData.Type.ATTACK:
			print(user.character_name, " atakuje za ", card.attack)
			target.take_damage(card.attack)
		CardData.Type.SKILL:
			print(user.character_name, "uzywa skill'a")

func end_battle(result_text: String):
	battle_in_progress = false
	print(result_text)

func connect_character_ui(character: Character, health_bar: ProgressBar):
	character.health_changed.connect(func(hp): health_bar.value = hp)
