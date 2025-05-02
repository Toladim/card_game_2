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

var user_ui_data : Dictionary = {}

var current_enemy : EnemyData = preload("res://custom_resouces/decks/enemy_data_01.tres")

var mana_reg_value : int = 1

var battle_in_progress : bool = false

func _ready():
	setup_ui_mapping()
	connect_character_ui(player)
	connect_character_ui(enemy)
	start_battle()

func start_battle():
	var player_data = GameSession.player_data
	if not player_data:
		push_error("brak danych gracza")
		return
	
	setup_character(player, player_data)
	setup_character(enemy, current_enemy)
	
	if player.deck.cards.size() < 5:
		player_card_pile.find_child("TextureRect").hide()#zmienic pozniej nazwe wezla odpowiedzialnego za texture deck_pile
	
	battle_in_progress = true
	draw_first_5_cards(player, player_card_container)
	draw_first_5_cards(enemy, enemy_card_container)
	start_turn(player, enemy) #mozna dodac pozniej randomizacje

func setup_character(character: Character, data: CharacterData) -> void:
	character.deck = Deck.new()
	for id in data.deck_ids:
		var card = DeckDatabase.get_card(id)
		if card:
			character.deck.cards.append(card)
	
	character.character_name = data.char_name
	character.health = data.max_health
	character.max_health = data.max_health
	character.mana = data.mana
	character.max_mana = data.max_mana
	
	var ui = user_ui_data.get(character)
	if ui:
		ui["hp_bar"].max_value = character.max_health
		ui["hp_bar"].value = character.health
		ui["mana_bar"].max_value = character.max_mana
		ui["mana_bar"].value = character.mana
		ui["name_label"].text = data.char_name
		ui["avatar"].texture = data.avatar

func draw_first_5_cards(user: Character, card_container: HBoxContainer):
	for i in range(min(5, user.deck.cards.size())):
		var card_data = user.deck.cards[i]
		var card = card_scene.instantiate()
		card.setup(card_data)
		card_container.add_child(card)

func start_turn(user: Character, target: Character):
	print(user.character_name, " ", user.mana)
	if not battle_in_progress:
		return
	user.add_mana(mana_reg_value)
	await get_tree().create_timer(5.0).timeout
	var card = user.deck.draw_card()
	if card:
		apply_card_effect(card, user, target)
		
	if target.health <=0 or target.deck.cards.size() <= 0:
		end_battle(str(user.character_name) +" wygrywa")
	elif user.health <=0 or user.deck.cards.size() <= 0:
		end_battle(str(target.character_name) +" wygrywa")
	else:
		start_turn(target, user)
		
func update_hand(user: Character):
	var data = user_ui_data.get(user)
	if data:
		var container = data["card_container"]
		if container.get_child_count() > 0:
			var card_ui = container.get_child(0)
			card_ui.queue_free()
		if user.deck.cards.size() > container.get_child_count():
			var next_card_data = user.deck.cards[container.get_child_count()]
			var new_card = card_scene.instantiate()
			new_card.setup(next_card_data)
			container.add_child(new_card)
		
func apply_card_effect(card: CardData, user: Character, target: Character):
	if user.mana < card.mana_cost:
		print("brakuje many")
		user.add_mana(2*mana_reg_value) #daje 2x wiecej many podczas nie zagranej rundy
		return
	
	user.mana -= card.mana_cost
	user.mana_changed.emit(user.mana)
	for effect in card.card_effects:
		effect.apply(user, target)
	update_hand(user)
func end_battle(result_text: String):
	battle_in_progress = false
	print(result_text)

func connect_character_ui(character: Character):
	var ui = user_ui_data.get(character)
	if not ui:
		push_error("Brak UI dla postaci")
		return

	if ui.has("hp_bar"):
		character.health_changed.connect(func(hp): ui["hp_bar"].value = hp)
		character.max_health_changed.connect(func(max_hp): ui["hp_bar"].max_value = max_hp)
	if ui.has("mana_bar"):
		character.mana_changed.connect(func(mana): ui["mana_bar"].value = mana)
		character.max_mana_changed.connect(func(max_mana): ui["mana_bar"].max_value = max_mana)
	
func setup_ui_mapping():
	user_ui_data[player] = {
		"card_container": player_card_container,
		"card_pile": player_card_pile,
		"avatar": player_avatar,
		"hp_bar": player_hp,
		"mana_bar": player_mana,
		"name_label": player_name
	}
	user_ui_data[enemy] = {
		"card_container": enemy_card_container,
		"card_pile": enemy_card_pile,
		"avatar": enemy_avatar,
		"hp_bar": enemy_hp,
		"mana_bar": enemy_mana,
		"name_label": enemy_name
	}
