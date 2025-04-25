extends Node

var player_data : PlayerData = null
var current_enemy : EnemyData = null
var phase : int = 0

func start_new_game():
	player_data = PlayerData.new()
	player_data.player_name = "Player"
	player_data.max_health = 3
	player_data.current_health = 3
	player_data.mana = 5
	player_data.deck_ids = ["punch", "kick", "block"]
	
	SaveManager.save_game(player_data)
	print("Nowa gra rozpoczęta.")

func continue_game():
	player_data = SaveManager.load_game()
	if not player_data:
		push_error("Nie udało się wczytać zapisu. Uruchamiam nową grę.")
		start_new_game()
