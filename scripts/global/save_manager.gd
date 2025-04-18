extends Node

const SAVE_PATH := "user://save_file.json"
var player_data : PlayerData = null

func new_game() -> void:
	player_data = PlayerData.new()
	player_data.player_name = "Player"
	#player_data.avatar = null
	player_data.current_health = 50
	player_data.max_health = 50
	player_data.mana = 5
	player_data.deck_ids = ["punch", "block"]
	save_game()

func save_game() -> void:
	if not player_data:
		push_error("Brak danych gracza do zapisu")
		return
	
	var data = {
		"player_name" = player_data.player_name,
		"current_health" = player_data.current_health,
		"max_health" = player_data.max_health,
		"mana" = player_data.mana,
		"deck_ids" = player_data.deck_ids
		}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	print("poprawnie zapisano gre")
	
func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("Plik zapisu nie istnieje")
		return 
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var result = JSON.parse_string(content)
	if typeof(result) != TYPE_DICTIONARY:
		push_error("Błędny typ danych zapisu")
		return
		
	player_data = PlayerData.new()
	player_data.player_name = result.get("player_name", "Unnamed")
	player_data.current_health = result.get("current_health", 10)
	player_data.max_health = result.get("max_health", 10)
	player_data.mana = result.get("mana", 2)
	var ids = result.get("deck_ids")
	var deck_ids : Array[String] = []
	
	for id in ids:
		if typeof(id) == TYPE_STRING:
			deck_ids.append(id)
		else:
			deck_ids.append(str(id))
	player_data.deck_ids = deck_ids
