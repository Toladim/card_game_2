extends Control

@onready var resume_button: Button = %resume_button
@onready var new_game_button: Button = %new_game_button
@onready var load_game_button: Button = %load_game_button
@onready var options_button: Button = %options_button
@onready var quit_button: Button = %quit_button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resume_button.pressed.connect(_on_resume_pressed)
	new_game_button.pressed.connect(_on_new_game_pressed)
	load_game_button.pressed.connect(_on_load_game_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_resume_pressed():
	print("resume")

func _on_new_game_pressed():
	print("new_game")
	start_new_game()
	get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")

func _on_load_game_pressed():
	print("load_game")

func _on_options_pressed():
	print("options")

func _on_quit_pressed():
	get_tree().quit()

func start_new_game():
	var default_deck_ids : Array[String] = ["punch"]
	SaveManager.save_deck(default_deck_ids)
	print("poprawnie wywyolano nowa gre")

func load_player_deck_from_save() -> Deck:
	var card_ids = SaveManager.load_deck()
	var deck = Deck.new()
	for id in card_ids:
		var card = DeckDatabase.get_card(id)
		if card != null:
			deck.cards.append(card)
	return deck
